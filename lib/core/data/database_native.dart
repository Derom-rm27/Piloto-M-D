import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<(DatabaseFactory, String)> databaseLocation() async {
  final dir = await getApplicationSupportDirectory();
  await dir.create(recursive: true);
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    return (databaseFactoryFfi, p.join(dir.path, 'procesos_md.sqlite'));
  }
  return (databaseFactory, p.join(dir.path, 'procesos_md.sqlite'));
}
