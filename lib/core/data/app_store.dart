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
};
const writableTables = {
  'personal',
  'jornadas_produccion',
  'lotes_produccion',
  'bobinas_produccion',
  'registro_asistencia',
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
      for (final table in primaryKeys.keys) {
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
