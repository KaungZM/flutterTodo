import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Todo.dart';

class TodoHelper {
  static final _databaseName = 'todo.db';
  static final _databaseVersion = 1;
  static final table = 'todo';
  TodoHelper._();
  static final TodoHelper todoHelper = TodoHelper._();
  static Database _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _initDatabase();
      return _database;
    }
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) {
    return db.execute(
        'CREATE TABLE $table(id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT, done INTEGER)');
  }

  Future<void> insertTodo(Todo todo) async {
    final Database db = await todoHelper.database;
    await db.insert(table, todo.toMap());
  }

  Future<void> updateTodo(Todo todo) async {
    final Database db = await todoHelper.database;
    await db.update(table, todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<List<Map<String, dynamic>>> retrieveData() async {
    final Database db = await todoHelper.database;
    print(await db.query(table));
    return await db.query(table);
  }

  Future<void> deleteTodo(int id) async {
    final Database db = await todoHelper.database;
    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearData() async {
    final Database db = await todoHelper.database;
    await db.rawQuery("Delete from $table");
  }
}
