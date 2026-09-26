import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'core/data/app_store.dart';
import 'core/data/local_database.dart';
import 'core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_PE');
  await Supabase.initialize(
    url: const String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: 'https://mkecqennrzncqrrsmqwt.supabase.co',
    ),
    publishableKey: const String.fromEnvironment(
      'SUPABASE_PUBLISHABLE_KEY',
      defaultValue: 'sb_publishable_90eGLsoATNqC4Wpzhjhz0g_kvYoXVYI',
    ),
  );
  try {
    final store = AppStore(await openLocalDatabase(), Supabase.instance.client);
    await store.load();
    final appearance = Appearance();
    await appearance.load();
    runApp(ProcesosApp(store: store, appearance: appearance));
    store.startSync();
  } catch (e) {
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'No se pudo abrir el almacenamiento local. Cierra y vuelve a abrir la aplicación. Tus datos no se han borrado.\n$e',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
