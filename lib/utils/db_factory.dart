import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseFactory {
  Future<Database> createDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'simpel.db');
    var database = await openDatabase(dbPath, version: 1, onCreate: populateDb);
    return database;
  }

  void populateDb(Database db, int version) async {
    await _createTableChats(db);
    await _creteTableMessages(db);
  }

  _createTableChats(Database db) async {
    await db
        .execute(
          """CREATE TABLE chats(
            id TEXT PRIMARY KEY,
            name TEXT,
            photo_url TEXT,
            type TEXT,
            members TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
          )""",
        )
        .then((_) => print('membuat tabel chats...'))
        .catchError((e) => print('error membuat tabel chats : $e'));
  }

  _creteTableMessages(Database db) async {
    await db
        .execute(
          """CREATE TABLE messages(
            chat_id TEXT NOT NULL,
            id TEXT PRIMARY KEY,
            sender TEXT NOT NULL,
            receiver TEXT NOT NULL,
            contents TEXT NOT NULL,
            lampiran TEXT,
            receipt TEXT NOT NULL,
            received_at TIMESTAMP NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
          )""",
        )
        .then((_) => print('membuat tabel messages...'))
        .catchError((e) => print('error membuat tabel messages : $e'));
  }
}
