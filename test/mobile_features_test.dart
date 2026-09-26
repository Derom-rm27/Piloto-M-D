import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:petro/app.dart';
import 'package:petro/core/data/app_store.dart';
import 'package:petro/core/theme/app_theme.dart';

Future<AppStore> mobileFixture() async {
  sqfliteFfiInit();
  final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
  await db.execute('CREATE TABLE records (entity TEXT NOT NULL,id TEXT NOT NULL,body TEXT NOT NULL,PRIMARY KEY(entity,id))');
  await db.execute('CREATE TABLE outbox (seq INTEGER PRIMARY KEY AUTOINCREMENT,body TEXT NOT NULL)');
  await db.execute('CREATE TABLE metadata (key TEXT PRIMARY KEY,value TEXT NOT NULL)');
  final data = <String, List<RowData>>{
    'personal': [
      {'id_trabajador': 'p1', 'nombre': 'Ana María', 'apellido_paterno': 'Quispe', 'apellido_materno': 'Puma', 'activo': true},
      {'id_trabajador': 'p2', 'nombre': 'Juan Carlos', 'apellido_paterno': 'Mamani', 'apellido_materno': 'Zea', 'activo': true},
    ],
    'registro_asistencia': [
      {'id_registro': 'r1', 'id_trabajador': 'p1', 'fecha_hora': '2026-09-11T07:00:00-05:00', 'tipo': 'ENTRADA', 'turno': 'Dia', 'linea': 'Galletas', 'fecha_jornada': '2026-09-11'},
      {'id_registro': 'r2', 'id_trabajador': 'p1', 'fecha_hora': '2026-09-11T17:00:00-05:00', 'tipo': 'SALIDA', 'turno': 'Dia', 'linea': 'Galletas', 'fecha_jornada': '2026-09-11'},
    ],
    'productos_envasados': [
      {'id_producto': 'prod', 'nombre_producto': 'Galleta con Kiwicha', 'tipo': 'Galletas'},
    ],
    'jornadas_produccion': [
      {
        'id_jornada': 'j1',
        'fecha': '2026-09-11',
        'turno': 'Dia',
        'tipo': 'Galletas',
        'id_supervisor': 'p1',
        'cant_batch': 2,
        'merma_piso_crudo': 1.1,
        'merma_maquina': 1.2,
        'merma_bobinas': 2,
        'caja_blanco_rotos': 1,
        'merma_piso_cocido': .5,
        'cinta_embalaje': 2,
        'observaciones': 'Jornada normal de prueba.',
      },
    ],
    'lotes_produccion': [
      {'id_lote': 'l1', 'id_jornada': 'j1', 'id_producto': 'prod', 'numero_lote': '0012', 'presentacion': '30 gr', 'cantidad': 12},
    ],
    'bobinas_produccion': [
      {'id_bobina': 'b1', 'id_jornada': 'j1', 'numero_bobina': 1, 'peso_bruto': 12.4, 'peso_neto': 12.15, 'tuco_envoltorio': .25},
    ],
  };
  for (final e in data.entries) {
    for (final r in e.value) {
      await db.insert('records', {'entity': e.key, 'id': r[primaryKeys[e.key]], 'body': jsonEncode(r)});
    }
  }
  final store = AppStore(db, null);
  await store.load();
  return store;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await initializeDateFormatting('es_PE');
  });

  testWidgets('Attendance floating dock and report exports fit 360 px mobile without overflow', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    final s = (await tester.runAsync(mobileFixture))!;
    final a = Appearance();

    await tester.pumpWidget(ProcesosApp(store: s, appearance: a));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // 1. Abrir menú y navegar a Control de Asistencia
    await tester.tap(find.byTooltip('Abrir menú de navegación'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Control de Asistencia').last);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // 2. Seleccionar un trabajador en Marcación Rápida
    expect(find.text('Ana María Quispe Puma'), findsOneWidget);
    await tester.tap(find.text('Ana María Quispe Puma'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // 3. Verificar que la barra flotante móvil se renderiza sin desbordamiento
    expect(find.text('1'), findsOneWidget);
    expect(find.text('seleccionados'), findsOneWidget);
    expect(find.text('Editar'), findsOneWidget);
    expect(find.text('ENTRADA'), findsOneWidget);
    expect(find.text('SALIDA'), findsOneWidget);

    // 4. Cambiar al subtab Reporte de Horas
    await tester.tap(find.text('Reporte de Horas'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // 5. Verificar que el selector de mes y los botones de exportación PDF y Excel están visibles
    expect(find.text('Reporte Consolidado de Asistencia'), findsOneWidget);
    expect(find.text('Excel'), findsOneWidget);
    expect(find.text('PDF'), findsOneWidget);

    // 5.1 Probar apertura del reporte individual de asistencia de un trabajador con Calendario y PDF
    await tester.ensureVisible(find.text('Ver fechas').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ver fechas').first);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Historial de Asistencia Individual'), findsOneWidget);
    expect(find.text('Compartir PDF'), findsOneWidget);
    expect(find.text('Calendario'), findsOneWidget);

    // Probar cambio a pestaña Resumen
    await tester.tap(find.text('Resumen'));
    await tester.pumpAndSettle();
    expect(find.text('Cómputo efectivo'), findsOneWidget);

    await tester.tap(find.text('Cerrar'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // 6. Navegar a Jornadas & Lotes
    await tester.tap(find.byTooltip('Abrir menú de navegación'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Jornadas & Lotes').last);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // 7. Verificar cabecera de producción y botones PDF/Excel
    expect(find.text('INFORMES DE PRODUCCIÓN'), findsOneWidget);
    expect(find.text('PDF'), findsOneWidget);
    expect(find.text('Excel'), findsOneWidget);

    // 8. Tocar Detalle en la primera jornada (hacer scroll horizontal para alcanzar la columna de acciones en móvil)
    await tester.ensureVisible(find.text('Detalle').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Detalle').first);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Detalle de Jornada'), findsOneWidget);
    expect(find.text('Descargar Formato PDF'), findsOneWidget);
    expect(find.text('Editar'), findsOneWidget);
    expect(find.text('Eliminar'), findsOneWidget);

    // 9. Probar que Eliminar abre el diálogo de confirmación con advertencia
    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();
    expect(find.text('Confirmar Eliminación'), findsOneWidget);
    expect(find.text('¿Estás seguro de que deseas eliminar esta jornada de producción?'), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    // 10. Cerrar modal de detalle
    await tester.tap(find.text('Cerrar'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // 11. Verificar que en Dashboard NO existe la tabla "HISTORIAL DE JORNADAS"
    await tester.tap(find.byTooltip('Abrir menú de navegación'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rendimiento (Dashboard)').last);
    await tester.pumpAndSettle();
    expect(find.text('HISTORIAL DE JORNADAS'), findsNothing);
    expect(find.text('DISTRIBUCIÓN DE MERMAS'), findsOneWidget);

    // 12. Verificar que en Configuración existe "3. VISTA PREVIA"
    await tester.tap(find.byTooltip('Abrir menú de navegación'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Configuración').last);
    await tester.pumpAndSettle();
    expect(find.text('1. MODO DE PANTALLA'), findsOneWidget);
    expect(find.text('3. VISTA PREVIA'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    s.dispose();
    await tester.runAsync(s.db.close);
  });
}
