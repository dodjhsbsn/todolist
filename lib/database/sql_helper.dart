// 数据库管理
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';


class SQLHelper {
  // 创建表
  static Future createTable(Database db, String tableName) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        orderIndex INTEGER NOT NULL DEFAULT 0,
        columnTitle TEXT,
        columnDescription TEXT,
        columnStatus INTEGER NOT NULL DEFAULT 0,
        columnGiveUp INTEGER NOT NULL DEFAULT 0,
        createTime TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        createWeek INTEGER NOT NULL DEFAULT -1,
        lastUpdateTime TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        finishedTime TIMESTAMP DEFAULT null,
        finishedWeek INTEGER NOT NULL DEFAULT -1,
        giveUpTime TIMESTAMP DEFAULT null
      );
    ''');
  }

  // 打开数据库
  static Future<Database> db() {
    return openDatabase(
      'todo.sql',
      version: 4,
      onCreate: (Database db, int version) async {
        await createTable(db, 'tasks');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion == 1 && newVersion == 2) {
          await db.execute('ALTER TABLE tasks ADD COLUMN columnGiveUp INTEGER NOT NULL DEFAULT 0;');
          await db.execute('ALTER TABLE tasks ADD COLUMN giveUpTime TIMESTAMP DEFAULT 0;');
        }
        if (oldVersion == 2 && newVersion == 3) {
          await db.execute('ALTER TABLE tasks ADD COLUMN createWeek INTEGER NOT NULL DEFAULT -1;');
          await db.execute('ALTER TABLE tasks ADD COLUMN finishedWeek INTEGER NOT NULL DEFAULT -1;');
        }

      },
    );
  }

  // 创建任务并返回id
  static Future<int> createTask(String? title, String? description) async {
    final Database db = await SQLHelper.db();
    DateTime nowTime = DateTime.now();
    // 获取最大的orderIndex
    const maxOrderIndexQuery = 'SELECT MAX(orderIndex) FROM tasks';
    final maxOrderIndexResult = await db.rawQuery(maxOrderIndexQuery);
    final maxOrderIndex = (maxOrderIndexResult.first['MAX(orderIndex)'] ?? 0) as int;
    final int newOrderIndex = maxOrderIndex + 1;

    final data = {
      'orderIndex': newOrderIndex,
      'columnTitle': title,
      'columnDescription': description,
      'columnStatus': 0, // 0: 未完成, 1: 已完成
      'createTime': nowTime.toString(),
      'createWeek': nowTime.weekday,
      'lastUpdateTime': nowTime.toString(),
    };

    final int id = await db.insert(
      'tasks',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  // 获取所有任务
  static Future<List<Map<String, dynamic>>> getTasks() async {
    final Database db = await SQLHelper.db();
    final List<Map<String, dynamic>> tasks = await db.query('tasks', orderBy: 'orderIndex');
    return tasks;
  }

  // 获取单个任务并返回id
  static Future<Map<String, dynamic>> getTask(int id) async {
    final Database db = await SQLHelper.db();
    final Map<String, dynamic> task = (await db.query('tasks', where: 'id = ?', whereArgs: [id])) as Map<String, dynamic>;
    return task;
  }

  // 更新任务
  static Future<int> updateTask(int id, String? title, String? description) async {
    final Database db = await SQLHelper.db();
    final data = {
      'columnTitle': title,
      'columnDescription': description,
      'lastUpdateTime': DateTime.now().toString(),
    };
    final int result = await db.update('tasks', data, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  // 更新任务完成状态
  static Future<int> changeStatus(int id, int status) async {
    final Database db = await SQLHelper.db();
    DateTime nowTime = DateTime.now();
    final data = {
      'columnStatus': status,
      'finishedTime': status==1? nowTime.toString(): null,
      'finishedWeek': status==1? nowTime.weekday: -1,
    };
    final int result = await db.update('tasks', data, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  // 删除任务
  static Future<void> deleteTask(int id) async {
    final Database db = await SQLHelper.db();
    try {
      // 删除任务的流程，先删除任务，再更新orderIndex，所删任务下面的任务orderIndex都减 1，最后更新sqlite_sequence，使其自增id减 1
      await db.transaction((txn) async {
        await txn.delete('tasks', where: 'id = ?', whereArgs: [id]);
        await txn.rawUpdate('UPDATE tasks SET orderIndex = orderIndex - 1 WHERE orderIndex > ?', [id]);
        await txn.rawUpdate("UPDATE sqlite_sequence SET seq = seq - 1 WHERE name = 'tasks'");
      });
    } catch (error) {
      debugPrint('删除失败: $error');
    }
  }

  // 更新任务排序
  static Future<void> updateTaskOrder(
      int oldId,
      int newId,
      String? title,
      String? description,
      int? status,
      ) async {
    final Database db = await SQLHelper.db();

    // 获取原位置任务和新位置任务的orderIndex
    final List<Map<String, dynamic>> oldTask = await db.query(
      'tasks',
      columns: ['orderIndex'],
      where: 'id = ?',
      whereArgs: [oldId],
    );
    final List<Map<String, dynamic>> newTask = await db.query(
      'tasks',
      columns: ['orderIndex'],
      where: 'id = ?',
      whereArgs: [newId],
    );

    // 获取sqlite数据库中的原位置任务和新位置任务的orderIndex，避免数据库数据和journals数据不一致
    final int oldOrderIndexDB = oldTask.isNotEmpty ? oldTask[0]['orderIndex'] : 0;
    final int newOrderIndexDB = newTask.isNotEmpty ? newTask[0]['orderIndex'] : 0;

    // 更新任务的流程，先比较原位置任务和新位置任务的orderIndex，再更新中间的任务orderIndex
    await db.transaction((txn) async {
      if (oldOrderIndexDB > newOrderIndexDB) {
        await txn.rawUpdate(
          'UPDATE tasks SET orderIndex = orderIndex + 1 WHERE orderIndex >= ? AND orderIndex < ?',
          [newOrderIndexDB, oldOrderIndexDB],
        );
      } else if (oldOrderIndexDB < newOrderIndexDB) {
        await txn.rawUpdate(
          'UPDATE tasks SET orderIndex = orderIndex - 1 WHERE orderIndex <= ? AND orderIndex > ?',
          [newOrderIndexDB, oldOrderIndexDB],
        );
      } else {
        debugPrint('oldOrderIndexDB == newOrderIndexDB');
        return; // No need to proceed if oldOrderIndexDB and newOrderIndexDB are the same
      }

      await txn.update(
        'tasks',
        {
          'columnTitle': title,
          'columnDescription': description,
          'columnStatus': status,
          'orderIndex': newOrderIndexDB,
        },
        where: 'id = ?',
        whereArgs: [oldId],
      );
    });
  }

}