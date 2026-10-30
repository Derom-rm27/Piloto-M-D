/// ==============================================================================
/// SISTEMA INTEGRADO DE CONTROL DE PLANTA - PROCESOS M&D
/// ------------------------------------------------------------------------------
/// AUTOR: Delfín Estanis Roque Mullisaca (DERM)
/// AFILIACIÓN: Escuela Profesional de Ingeniería de Software y Sistemas - UNAJ
/// EXPEDIENTE: Registro de Soporte Lógico (Software) - INDECOPI
/// ==============================================================================

import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

typedef RowData = Map<String, dynamic>;
const primaryKeys = {
  'personal': 'id_trabajador',
  'productos_envasados': 'id_producto',
  'jornadas_produccion': 'id_jornada',
  'lotes_produccion': 'id_lote',
  'bobinas_produccion': 'id_bobina',
  'registro_asistencia': 'id_registro',
  'almacen_insumos': 'id_insumo',
  'almacen_lotes': 'id_lote',
  'almacen_movimientos': 'id_movimiento',
};
const remoteSyncTables = [
  'personal',
  'productos_envasados',
  'jornadas_produccion',
  'lotes_produccion',
  'bobinas_produccion',
  'registro_asistencia',
];
const writableTables = {
  'personal',
  'jornadas_produccion',
  'lotes_produccion',
  'bobinas_produccion',
  'registro_asistencia',
  'almacen_insumos',
  'almacen_lotes',
  'almacen_movimientos',
};

class AppStore extends ChangeNotifier {
  AppStore(this.db, this.client);
  final Database db;
  final SupabaseClient? client;
  final Map<String, List<RowData>> _data = {};
  bool connected = false, syncing = false, hydrated = false;
  int pending = 0;
  String? syncError;
  Timer? _timer;
  List<RowData> rows(String table) =>
      (_data[table] ?? []).where((r) => r['deleted_at'] == null).toList();
  RowData? find(String table, dynamic id) {
    for (final r in _data[table] ?? <RowData>[]) {
      if (r[primaryKeys[table]] == id) return Map.of(r);
    }
    return null;
  }

  Future<void> load() async {
    _data.clear();
    for (final r in await db.query('records')) {
      (_data[r['entity'] as String] ??= []).add(
        Map<String, dynamic>.from(jsonDecode(r['body'] as String)),
      );
    }
    if ((_data['almacen_insumos'] ?? []).isEmpty) {
      await _seedWarehouse(db);
      _data.clear();
      for (final r in await db.query('records')) {
        (_data[r['entity'] as String] ??= []).add(
          Map<String, dynamic>.from(jsonDecode(r['body'] as String)),
        );
      }
    }
    pending =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT count(*) FROM outbox'),
        ) ??
        0;
    hydrated = (await db.query(
      'metadata',
      where: 'key=?',
      whereArgs: ['hydrated'],
    )).isNotEmpty;
    notifyListeners();
  }

  Future<void> _seedWarehouse(Database db) async {
    final insumos = [
      {'id_insumo': '1', 'id_num': 1, 'nombre': 'Harina de Trigo Especial', 'categoria': 'MATERIA_PRIMA', 'unidad': 'Sacos x 50 kg', 'kg_por_unidad': 50.0, 'kg_por_batch': 83.0},
      {'id_insumo': '2', 'id_num': 2, 'nombre': 'Harina de Quinua', 'categoria': 'MATERIA_PRIMA', 'unidad': 'Sacos x 25 kg', 'kg_por_unidad': 25.0, 'kg_por_batch': 2.0},
      {'id_insumo': '3', 'id_num': 3, 'nombre': 'Harina de Kiwicha', 'categoria': 'MATERIA_PRIMA', 'unidad': 'Sacos x 25 kg', 'kg_por_unidad': 25.0, 'kg_por_batch': 2.0},
      {'id_insumo': '4', 'id_num': 4, 'nombre': 'Harina de Maca', 'categoria': 'MATERIA_PRIMA', 'unidad': 'Sacos x 25 kg', 'kg_por_unidad': 25.0, 'kg_por_batch': 2.0},
      {'id_insumo': '5', 'id_num': 5, 'nombre': 'Salvado de Trigo', 'categoria': 'MATERIA_PRIMA', 'unidad': 'Sacos x 40 kg', 'kg_por_unidad': 40.0, 'kg_por_batch': 3.0},
      {'id_insumo': '6', 'id_num': 6, 'nombre': 'Hojuela de Quinua', 'categoria': 'MATERIA_PRIMA', 'unidad': 'Sacos x 25 kg', 'kg_por_unidad': 25.0, 'kg_por_batch': 3.0},
      {'id_insumo': '7', 'id_num': 7, 'nombre': 'Manteca Vegetal Industrial', 'categoria': 'INSUMOS', 'unidad': 'Cajas x 15 kg', 'kg_por_unidad': 15.0, 'kg_por_batch': 11.0},
      {'id_insumo': '8', 'id_num': 8, 'nombre': 'Azúcar Industrial', 'categoria': 'INSUMOS', 'unidad': 'Sacos x 50 kg', 'kg_por_unidad': 50.0, 'kg_por_batch': 10.0},
      {'id_insumo': '9', 'id_num': 9, 'nombre': 'Leche en Polvo Descremada', 'categoria': 'INSUMOS', 'unidad': 'Sacos x 25 kg', 'kg_por_unidad': 25.0, 'kg_por_batch': 1.0},
      {'id_insumo': '10', 'id_num': 10, 'nombre': 'Cloruro de Sodio (Sal)', 'categoria': 'INSUMOS', 'unidad': 'Sacos x 25 kg', 'kg_por_unidad': 25.0, 'kg_por_batch': 0.45},
      {'id_insumo': '11', 'id_num': 11, 'nombre': 'Bicarbonato de Sodio', 'categoria': 'INSUMOS', 'unidad': 'Sacos x 25 kg', 'kg_por_unidad': 25.0, 'kg_por_batch': 0.45},
      {'id_insumo': '12', 'id_num': 12, 'nombre': 'Bicarbonato de Amonio', 'categoria': 'INSUMOS', 'unidad': 'Sacos x 25 kg', 'kg_por_unidad': 25.0, 'kg_por_batch': 0.15},
      {'id_insumo': '13', 'id_num': 13, 'nombre': 'Lecitina de Soya', 'categoria': 'INSUMOS', 'unidad': 'Baldes x 20 kg', 'kg_por_unidad': 20.0, 'kg_por_batch': 0.40},
      {'id_insumo': '14', 'id_num': 14, 'nombre': 'Propionato de Calcio', 'categoria': 'INSUMOS', 'unidad': 'Sacos x 25 kg', 'kg_por_unidad': 25.0, 'kg_por_batch': 0.04},
      {'id_insumo': '15', 'id_num': 15, 'nombre': 'BHT Antioxidante', 'categoria': 'INSUMOS', 'unidad': 'Frascos x 1 kg', 'kg_por_unidad': 1.0, 'kg_por_batch': 0.02},
      {'id_insumo': '16', 'id_num': 16, 'nombre': 'Cajas Corrugadas Verdes M&D', 'categoria': 'EMPAQUES', 'unidad': 'Paquetes x 20 u', 'kg_por_unidad': 20.0, 'kg_por_batch': 11.2},
      {'id_insumo': '17', 'id_num': 17, 'nombre': 'Cajas Corrugadas Azules M&D', 'categoria': 'EMPAQUES', 'unidad': 'Paquetes x 20 u', 'kg_por_unidad': 20.0, 'kg_por_batch': 11.2},
      {'id_insumo': '18', 'id_num': 18, 'nombre': 'Cinta de Embalaje 2 pulg.', 'categoria': 'EMPAQUES', 'unidad': 'Cajas x 32 rollos', 'kg_por_unidad': 32.0, 'kg_por_batch': 0.15},
      {'id_insumo': '19', 'id_num': 19, 'nombre': 'Bobinas de Envoltura Galletas', 'categoria': 'EMPAQUES', 'unidad': 'Bobinas x 15 kg', 'kg_por_unidad': 15.0, 'kg_por_batch': 0.75},
    ];

    final lotes = [
      {'id_lote': 'lot-1', 'prod_id': 1, 'nro_lote': '2608', 'f_ingreso': '2026-08-15', 'f_vence': '2026-11-10', 'saldo': 10.0},
      {'id_lote': 'lot-2', 'prod_id': 1, 'nro_lote': '2609', 'f_ingreso': '2026-09-05', 'f_vence': '2027-03-05', 'saldo': 18.0},
      {'id_lote': 'lot-3', 'prod_id': 2, 'nro_lote': '1401', 'f_ingreso': '2026-08-18', 'f_vence': '2027-02-18', 'saldo': 2.0},
      {'id_lote': 'lot-4', 'prod_id': 3, 'nro_lote': '2206', 'f_ingreso': '2026-08-22', 'f_vence': '2027-02-22', 'saldo': 1.0},
      {'id_lote': 'lot-5', 'prod_id': 4, 'nro_lote': '2704', 'f_ingreso': '2026-08-20', 'f_vence': '2027-02-20', 'saldo': 2.0},
      {'id_lote': 'lot-6', 'prod_id': 5, 'nro_lote': '3108', 'f_ingreso': '2026-09-10', 'f_vence': '2027-01-10', 'saldo': 1.0},
      {'id_lote': 'lot-7', 'prod_id': 6, 'nro_lote': '4015', 'f_ingreso': '2026-09-12', 'f_vence': '2027-03-12', 'saldo': 3.0},
      {'id_lote': 'lot-8', 'prod_id': 7, 'nro_lote': '5020', 'f_ingreso': '2026-08-10', 'f_vence': '2026-11-05', 'saldo': 8.0},
      {'id_lote': 'lot-9', 'prod_id': 8, 'nro_lote': '6102', 'f_ingreso': '2026-08-25', 'f_vence': '2028-08-25', 'saldo': 6.0},
      {'id_lote': 'lot-10', 'prod_id': 9, 'nro_lote': '7011', 'f_ingreso': '2026-09-04', 'f_vence': '2027-06-04', 'saldo': 1.0},
      {'id_lote': 'lot-11', 'prod_id': 10, 'nro_lote': '8015', 'f_ingreso': '2026-07-15', 'f_vence': '2029-07-15', 'saldo': 1.0},
      {'id_lote': 'lot-12', 'prod_id': 11, 'nro_lote': '8020', 'f_ingreso': '2026-08-12', 'f_vence': '2027-08-12', 'saldo': 1.0},
      {'id_lote': 'lot-13', 'prod_id': 12, 'nro_lote': '8025', 'f_ingreso': '2026-08-12', 'f_vence': '2027-08-12', 'saldo': 1.0},
      {'id_lote': 'lot-14', 'prod_id': 13, 'nro_lote': '9005', 'f_ingreso': '2026-08-20', 'f_vence': '2027-02-20', 'saldo': 1.0},
      {'id_lote': 'lot-15', 'prod_id': 14, 'nro_lote': '9010', 'f_ingreso': '2026-08-10', 'f_vence': '2027-08-10', 'saldo': 1.0},
      {'id_lote': 'lot-16', 'prod_id': 15, 'nro_lote': '9015', 'f_ingreso': '2026-08-10', 'f_vence': '2027-08-10', 'saldo': 2.0},
      {'id_lote': 'lot-17', 'prod_id': 16, 'nro_lote': '1104', 'f_ingreso': '2026-09-10', 'f_vence': '2028-09-10', 'saldo': 15.0},
      {'id_lote': 'lot-18', 'prod_id': 17, 'nro_lote': '1105', 'f_ingreso': '2026-09-10', 'f_vence': '2028-09-10', 'saldo': 12.0},
      {'id_lote': 'lot-19', 'prod_id': 18, 'nro_lote': '1201', 'f_ingreso': '2026-09-01', 'f_vence': '2028-09-01', 'saldo': 4.0},
      {'id_lote': 'lot-20', 'prod_id': 19, 'nro_lote': '1301', 'f_ingreso': '2026-09-15', 'f_vence': '2027-09-15', 'saldo': 3.0},
    ];

    final movimientos = [
      {'id_movimiento': 'mov-1', 'fecha_hora': '16/10/2026 08:30', 'tipo': 'SALIDA', 'prod_id': 1, 'prod': 'Harina de Trigo Especial', 'lote': '2608', 'cant': 8.0, 'unidad': 'Sacos', 'operario': 'Delfin Estanis Roque Mullisaca', 'destino': 'Línea Galletas - Horno Túnel', 'jornada_id': 'JRN-2026-1016-D', 'guia': null, 'proveedor': null},
      {'id_movimiento': 'mov-2', 'fecha_hora': '16/10/2026 08:45', 'tipo': 'SALIDA', 'prod_id': 7, 'prod': 'Manteca Vegetal Industrial', 'lote': '5020', 'cant': 4.0, 'unidad': 'Cajas', 'operario': 'Vianet Charca Mamani', 'destino': 'Línea Galletas - Horno Túnel', 'jornada_id': 'JRN-2026-1016-D', 'guia': null, 'proveedor': null},
      {'id_movimiento': 'mov-3', 'fecha_hora': '15/10/2026 19:20', 'tipo': 'SALIDA', 'prod_id': 1, 'prod': 'Harina de Trigo Especial', 'lote': '2608', 'cant': 10.0, 'unidad': 'Sacos', 'operario': 'Delfin Estanis Roque Mullisaca', 'destino': 'Línea Galletas - Horno Túnel', 'jornada_id': 'JRN-2026-1015-N', 'guia': null, 'proveedor': null},
      {'id_movimiento': 'mov-4', 'fecha_hora': '10/10/2026 11:15', 'tipo': 'ENTRADA', 'prod_id': 1, 'prod': 'Harina de Trigo Especial', 'lote': '2609', 'cant': 18.0, 'unidad': 'Sacos', 'operario': 'Amelia Evelyn Ticona Pari', 'destino': 'Almacén MP - Rack A-02', 'jornada_id': null, 'guia': 'GR-001-0842', 'proveedor': 'Molino del Sur S.A.'},
    ];

    await db.transaction((txn) async {
      for (final i in insumos) {
        await txn.insert('records', {
          'entity': 'almacen_insumos',
          'id': i['id_insumo'],
          'body': jsonEncode(i),
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      for (final l in lotes) {
        await txn.insert('records', {
          'entity': 'almacen_lotes',
          'id': l['id_lote'],
          'body': jsonEncode(l),
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      for (final m in movimientos) {
        await txn.insert('records', {
          'entity': 'almacen_movimientos',
          'id': m['id_movimiento'],
          'body': jsonEncode(m),
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  Future<void> save(String table, RowData after) => saveBatch([(table, after)]);
  // Data and durable queue commit together: no successful UI save without recovery data.
  Future<void> saveBatch(List<(String, RowData)> changes) async {
    await db.transaction((txn) async {
      final ops = <RowData>[];
      for (final (table, after) in changes) {
        if (!writableTables.contains(table)) {
          throw ArgumentError('Tabla no editable');
        }
        final id = after[primaryKeys[table]] as String;
        final old = await txn.query(
          'records',
          where: 'entity=? AND id=?',
          whereArgs: [table, id],
        );
        final before = old.isEmpty
            ? null
            : jsonDecode(old.first['body'] as String);
        ops.add({'table': table, 'before': before, 'after': after});
        await txn.insert('records', {
          'entity': table,
          'id': id,
          'body': jsonEncode(after),
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      if (ops.isNotEmpty) await txn.insert('outbox', {'body': jsonEncode(ops)});
    });
    await load();
    unawaited(sync());
  }

  Future<void> remove(String table, RowData row) => save(table, {
    ...row,
    'deleted_at': DateTime.now().toUtc().toIso8601String(),
  });
  void startSync() {
    unawaited(sync());
    _timer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => unawaited(sync()),
    );
  }

  Future<void> sync() async {
    if (syncing || client == null) return;
    syncing = true;
    notifyListeners();
    try {
      await client!
          .from('productos_envasados')
          .select('id_producto')
          .limit(1)
          .timeout(const Duration(seconds: 12));
      connected = true;
      syncError = null;
      while (true) {
        final queue = await db.query('outbox', orderBy: 'seq', limit: 1);
        if (queue.isEmpty) break;
        final item = queue.first;
        await client!
            .rpc(
              'md_apply_changes',
              params: {'p_changes': jsonDecode(item['body'] as String)},
            )
            .timeout(const Duration(seconds: 20));
        await db.delete('outbox', where: 'seq=?', whereArgs: [item['seq']]);
      }
      final remote = <String, List<RowData>>{};
      for (final table in remoteSyncTables) {
        final all = <RowData>[];
        for (var offset = 0; ; offset += 500) {
          final page = await client!
              .from(table)
              .select()
              .order(primaryKeys[table]!)
              .range(offset, offset + 499)
              .timeout(const Duration(seconds: 20));
          all.addAll(page);
          if (page.length < 500) break;
        }
        remote[table] = all;
      }
      await db.transaction((txn) async {
        final protected = <String>{};
        for (final q in await txn.query('outbox')) {
          for (final op in jsonDecode(q['body'] as String) as List) {
            protected.add(
              '${op['table']}/${op['after'][primaryKeys[op['table']]]}',
            );
          }
        }
        for (final entry in remote.entries) {
          final ids = entry.value
              .map((r) => r[primaryKeys[entry.key]] as String)
              .toSet();
          for (final local in await txn.query(
            'records',
            where: 'entity=?',
            whereArgs: [entry.key],
          )) {
            if (!ids.contains(local['id']) &&
                !protected.contains('${entry.key}/${local['id']}')) {
              await txn.delete(
                'records',
                where: 'entity=? AND id=?',
                whereArgs: [entry.key, local['id']],
              );
            }
          }
          for (final row in entry.value) {
            final id = row[primaryKeys[entry.key]];
            if (protected.contains('${entry.key}/$id')) continue;
            await txn.insert('records', {
              'entity': entry.key,
              'id': id,
              'body': jsonEncode(row),
            }, conflictAlgorithm: ConflictAlgorithm.replace);
          }
        }
        await txn.insert('metadata', {
          'key': 'hydrated',
          'value': 'true',
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      });
    } on PostgrestException catch (e) {
      syncError = e.message.contains('MD_CONFLICT')
          ? 'Hay cambios en otro dispositivo. Conservamos tus cambios locales; revisa el conflicto en Configuración.'
          : 'No se pudo sincronizar: ${e.message}';
    } catch (_) {
      connected = false;
      syncError = null;
    } finally {
      syncing = false;
      await load();
    }
  }

  String get status =>
      syncError ??
      (pending > 0
          ? '$pending envíos pendientes · guardados en este dispositivo'
          : !hydrated
          ? 'Conéctate para descargar los registros iniciales'
          : syncing
          ? 'Sincronizando registros…'
          : connected
          ? 'Todos los registros se han subido'
          : 'Sin envíos pendientes · copia local disponible');
  Future<String> backup() async => jsonEncode({
    'version': 1,
    'records': await db.query('records'),
    'outbox': await db.query('outbox'),
  });
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
