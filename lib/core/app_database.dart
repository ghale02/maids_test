import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static const _databaseName = 'todos';
  static const _databaseVersion = 1;
  static final Map<int, List<String>> _queries = {
    1: [
      """
        CREATE TABLE todos (
            id INTEGER PRIMARY KEY,
            todo TEXT NOT NULL,
            completed BOOLEAN NOT NULL,
            userId INTEGER NOT NULL
        );
        """,
    ]
  };

  static Future<Database> get instance => openDatabase(
        _databaseName,
        version: _databaseVersion,
        onCreate: (db, version) async {
          for (var query in _queries[version]!) {
            await db.execute(query);
          }
        },
      );
}
