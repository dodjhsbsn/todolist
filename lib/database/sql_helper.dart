import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';


class SQLHelper {
  static Future createTable(Database db, String tableName) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        columnTitle TEXT NOT NULL,
        columnDescription TEXT,
        columnStatus INTEGER NOT NULL DEFAULT 0,
        createTime TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  static Future<Database> db() {
    return openDatabase(
      'todo.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await createTable(db, 'tasks');
      },
    );
  }

  static Future<int> createTask(String title, String? description) async {
    final Database db = await SQLHelper.db();
    final data = {
      'columnTitle': title,
      'columnDescription': description,
    };
    final int id = await db.insert(
        'tasks', data, conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getTasks() async {
    final Database db = await SQLHelper.db();
    final List<Map<String, dynamic>> tasks = await db.query(
        'tasks', orderBy: 'id');
    return tasks;
  }

  static Future<List<Map<String, dynamic>>> getTask(int id) async {
    final Database db = await SQLHelper.db();
    final List<Map<String, dynamic>> task = await db.query(
        'tasks', where: 'id = ?', whereArgs: [id]);
    return task;
  }

  static Future<int> updateTask(int id, String title,
      String? description) async {
    final Database db = await SQLHelper.db();
    final data = {
      'columnTitle': title,
      'columnDescription': description,
      'createTime': DateTime.now().toString(),
    };
    final int result = await db.update(
        'tasks', data, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  static deleteTask(int id) async {
    final Database db = await SQLHelper.db();
    try {
      await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
    } catch (error){
      debugPrint('删除失败:$error');
    }
  }
}