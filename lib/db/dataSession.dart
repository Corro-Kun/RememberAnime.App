import 'package:sqflite/sqflite.dart';

class dataSession {
  Future<Database> OpenDB() async {
    final Future<Database> database = openDatabase(
      "C0rr0K4n.db",
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE session(idsession INTEGER PRIMARY KEY AUTO_INCREMENT, title TEXT)",
        );
      },
      version: 1,
    );

    return database;
  }

  Future<void> insertSession(String title) async {}
}
