import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api_config.dart';
import 'database.dart';
import 'database_connection.dart';
import 'sync_api.dart';
import 'sync_engine.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase(openDatabaseConnection());
  ref.onDispose(database.close);
  return database;
});

final syncApiProvider = Provider<HttpSyncApi>((ref) {
  return HttpSyncApi(baseUrl: Uri.parse(ref.watch(apiBaseUrlProvider)));
});

final syncEngineProvider = Provider<SyncEngine>((ref) {
  return SyncEngine(
    ref.watch(appDatabaseProvider),
    ref.watch(syncApiProvider),
  );
});
