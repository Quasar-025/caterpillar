// ignore_for_file: deprecated_member_use

import 'package:drift/drift.dart';
import 'package:drift/web.dart';

QueryExecutor openDatabaseConnection() {
  // The hackathon web preview uses sql.js; mobile builds use native SQLite.
  return WebDatabase('cat_operator_copilot');
}
