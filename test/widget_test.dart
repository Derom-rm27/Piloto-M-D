import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:petro/app.dart';
import 'package:petro/core/data/app_store.dart';
import 'package:petro/core/domain/attendance.dart';
import 'package:petro/core/domain/production.dart';
import 'package:petro/core/theme/app_theme.dart';
import 'package:petro/features/reports/report_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:excel/excel.dart';

Future<AppStore> fixture() async {
  sqfliteFfiInit();
  final db=await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
  await db.execute('CREATE TABLE IF NOT EXISTS records (entity TEXT NOT NULL,id TEXT NOT NULL,body TEXT NOT NULL,PRIMARY KEY(entity,id))');
  await db.execute('CREATE TABLE IF NOT EXISTS outbox (seq INTEGER PRIMARY KEY AUTOINCREMENT,body TEXT NOT NULL)');
  await db.execute('CREATE TABLE IF NOT EXISTS metadata (key TEXT PRIMARY KEY,value TEXT NOT NULL)');
  await db.delete('records');
  await db.delete('outbox');
  await db.delete('metadata');
  final data=<String,List<RowData>>{
    'personal':[{'id_trabajador':'p','nombre':'Ana María','apellido_paterno':'Quispe','apellido_materno':'Puma','activo':true}],
    'productos_envasados':[{'id_producto':'prod','nombre_producto':'Galleta con Kiwicha','tipo':'Galletas'},{'id_producto':'bar','nombre_producto':'Barra de Kiwicha','tipo':'Barras'}],
    'jornadas_produccion':[{'id_jornada':'j','fecha':'2026-09-11','turno':'Dia','tipo':'Galletas','id_supervisor':'p','cant_batch':2,'merma_piso_crudo':1.1,'merma_maquina':1.2,'merma_bobinas':2,'caja_blanco_rotos':1,'merma_piso_cocido':.5,'cinta_embalaje':2,'observaciones':'Documento de prueba. No corresponde a un registro real.'},{'id_jornada':'b','fecha':'2026-09-12','turno':'Noche','tipo':'Barras','id_supervisor':'p','merma_bobinas':3.45,'batch_jarabe':2,'observaciones':'Prueba del formato de barras.'}],
    'lotes_produccion':[{'id_lote':'l1','id_jornada':'j','id_producto':'prod','numero_lote':'0012','presentacion':'30 gr','cantidad':12},{'id_lote':'l2','id_jornada':'j','id_producto':'prod','numero_lote':'0013','presentacion':'48 gr','cantidad':12},{'id_lote':'l3','id_jornada':'b','id_producto':'bar','numero_lote':'0306','presentacion':'30 gr','cantidad':175}],
    'bobinas_produccion':[for(var i=0;i<3;i++){'id_bobina':'bj$i','id_jornada':'j','numero_bobina':i+1,'peso_bruto':12.4,'peso_neto':12.15,'tuco_envoltorio':.25},for(var i=0;i<2;i++){'id_bobina':'bb$i','id_jornada':'b','numero_bobina':i+1,'peso_bruto':14.8,'peso_neto':14.5,'tuco_envoltorio':.3}],
  };
  for(final e in data.entries){for(final r in e.value){await db.insert('records',{'entity':e.key,'id':r[primaryKeys[e.key]],'body':jsonEncode(r)});}}
  final store=AppStore(db,null);await store.load();return store;
}
RowData mark(String id,String timestamp,String type,{String turn='Noche',String? date,String line='Galletas'})=>{'id_registro':id,'id_trabajador':'p','fecha_hora':timestamp,'tipo':type,'turno':turn,'linea':line,'fecha_jornada':?date};
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(()async{await initializeDateFormatting('es_PE');});
  test('Monthly report pairs night shift across month and keeps full name',() {
    final rows=attendanceReport([{'id_trabajador':'p','nombre':'Ana María','apellido_paterno':'Quispe','apellido_materno':'Puma','activo':false}],[mark('a','2026-08-31T19:00:00-05:00','ENTRADA'),mark('b','2026-09-01T05:00:00-05:00','SALIDA')],DateTime(2026,8));
    expect(rows.single.hours,10);expect(rows.single.dates.length,1);expect(rows.single.name,'Ana María Quispe Puma');
    expect(attendanceReport([rows.single.person],[mark('a','2026-08-31T19:00:00-05:00','ENTRADA'),mark('b','2026-09-01T05:00:00-05:00','SALIDA')],DateTime(2026,9)),isEmpty);
  });
  test('Missing and ambiguous marks never invent payable hours',(){
    final p=[{'id_trabajador':'p','nombre':'Ana'}];
    final rows=attendanceReport(p,[mark('a','2026-09-01T19:00:00-05:00','ENTRADA'),mark('b','2026-09-01T20:00:00-05:00','ENTRADA'),mark('c','2026-09-02T05:00:00-05:00','SALIDA')],DateTime(2026,9));
    expect(rows.single.hours,0);expect(rows.single.incomplete,greaterThan(0));
  });
  test('Single entrada without salida reflects labor day and computes hours',(){
    final p=[{'id_trabajador':'p','nombre':'Ana'}];
    final rows=attendanceReport(p,[mark('a','2026-09-01T07:00:00-05:00','ENTRADA',turn:'Dia')],DateTime(2026,9));
    expect(rows.single.dates.length,1);
    expect(rows.single.dayShifts.length,1);
    expect(rows.single.sinSalida,1);
    expect(rows.single.incomplete,0);
    expect(rows.single.hours,8);
  });
  test('SQLite save is durable and retains before/after for offline edits',()async{
    final store=await fixture();
    final p=store.rows('personal').single;
    await store.save('personal',{...p,'telefono':'123'});
    await store.save('personal',{...store.rows('personal').single,'telefono':'456'});
    expect(store.pending,2);
    final queue=await store.db.query('outbox',orderBy:'seq');
    expect(jsonDecode(queue.last['body'] as String)[0]['before']['telefono'],'123');
    final reopened=AppStore(store.db,null);await reopened.load();expect(reopened.rows('personal').single['telefono'],'456');
    await expectLater(store.saveBatch([('personal',{...p,'nombre':'Changed'}),('invalid',{'id':'x'})]),throwsArgumentError);
    await store.load();expect(store.rows('personal').single['nombre'],p['nombre']);
    reopened.dispose();store.dispose();await store.db.close();
  });
  test('Mass balance uses recipes, actual packaging and excludes packaging waste',()async{
    final s=await fixture();final j=Production(s,s.find('jornadas_produccion','j')!);
    expect(j.inputKg,closeTo(235.82,.001));expect(j.kilograms,closeTo(182.16,.001));expect(j.yieldPercent,closeTo(77.245,.01));expect(j.goodYield,true);
    expect(Production(s,s.find('jornadas_produccion','b')!).yieldPercent,isNull);
    s.dispose();await s.db.close();
  });
  test('PDF/XLSX exports preserve requested columns and lot codes',()async{
    final s=await fixture();final out=Directory('build/verification')..createSync(recursive:true);
    final attendance=attendanceReport(s.rows('personal'),[mark('a','2026-09-01T19:00:00-05:00','ENTRADA'),mark('b','2026-09-02T05:00:00-05:00','SALIDA')],DateTime(2026,9));
    final bytes=ReportService.attendanceExcel(attendance,'septiembre de 2026');final book=Excel.decodeBytes(bytes);
    expect(book['Asistencia'].rows[2][1]!.value.toString(),'Ana María Quispe Puma');expect(num.parse(book['Asistencia'].rows[2][5]!.value.toString()),10);
    await File('${out.path}/asistencia.xlsx').writeAsBytes(bytes);
    await File('${out.path}/asistencia.pdf').writeAsBytes(await ReportService.attendancePdf(attendance,'septiembre de 2026'));
    final indPdfBytes = await ReportService.individualAttendancePdf(attendance.first, DateTime(2026, 9));
    expect(indPdfBytes.isNotEmpty, true);
    await File('${out.path}/asistencia_individual.pdf').writeAsBytes(indPdfBytes);
    final jobs=s.rows('jornadas_produccion').map((r)=>Production(s,r)).toList();
    await File('${out.path}/jornadas.pdf').writeAsBytes(await ReportService.productionPdf(jobs));
    await File('${out.path}/jornadas.xlsx').writeAsBytes(ReportService.productionExcel(jobs));
    expect(Excel.decodeBytes(ReportService.productionExcel(jobs))['Jornadas'].rows[2][4]!.value.toString(),'0012');
    s.dispose();await s.db.close();
  });
  for(final width in [360.0,1440.0]) {
    testWidgets('Navigation and forms fit ${width.toInt()} px',(tester)async{
      tester.view.physicalSize=Size(width,900);tester.view.devicePixelRatio=1;
      addTearDown(tester.view.resetPhysicalSize);addTearDown(tester.view.resetDevicePixelRatio);
      SharedPreferences.setMockInitialValues({});final s=(await tester.runAsync(fixture))!;final a=Appearance();
      await tester.pumpWidget(ProcesosApp(store:s,appearance:a));await tester.pumpAndSettle();expect(tester.takeException(),isNull);
      if(width<1050){await tester.tap(find.byTooltip('Abrir menú de navegación'));await tester.pumpAndSettle();}
      await tester.tap(find.text('Personal').last);await tester.pumpAndSettle();expect(find.text('Ana María Quispe Puma'),findsOneWidget);expect(tester.takeException(),isNull);
      await tester.tap(find.text('Nuevo personal'));await tester.pumpAndSettle();expect(tester.takeException(),isNull);
      await tester.tap(find.text('Cancelar'));await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox());s.dispose();await tester.runAsync(s.db.close);
    });
  }
}
