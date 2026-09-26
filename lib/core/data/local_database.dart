import 'package:sqflite/sqflite.dart';
import 'database_native.dart'
    if (dart.library.js_interop) 'database_web.dart'
    as platform;

Future<Database> openLocalDatabase() async {
  final (factory, path) = await platform.databaseLocation();
  return factory.openDatabase(
    path,
    options: OpenDatabaseOptions(
      version: 1,
      onCreate: (db, _) async {
        await db.execute(
          'CREATE TABLE records (entity TEXT NOT NULL, id TEXT NOT NULL, body TEXT NOT NULL, PRIMARY KEY(entity,id))',
        );
        await db.execute(
          'CREATE TABLE outbox (seq INTEGER PRIMARY KEY AUTOINCREMENT, body TEXT NOT NULL)',
        );
        await db.execute(
          'CREATE TABLE metadata (key TEXT PRIMARY KEY, value TEXT NOT NULL)',
        );
      },
    ),
  );
}
