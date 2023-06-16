import 'package:sqflite/sqflite.dart';

class SqlManager{
  // 数据库版本
  static const _VERSION = 1;
  // 数据库名称
  static const _DB_NAME = 'todo.db';
  // 表名
  static const _TABLE_NAME = 'todo';
  // 表中的列
  static const _ID = 'id';
  // 单例
  static SqlManager? _instance;
  // 工厂构造函数
  factory SqlManager() => _getInstance();
  // 内部构造函数
  SqlManager._internal();
  // 获取单例
  static SqlManager _getInstance() {
    _instance ??= SqlManager._internal();
    return _instance!;
  }
  // 数据库对象
  static late Database _database;
  // 初始化
  static init() async {
    var databasesPath = await getDatabasesPath();
    String path = databasesPath + _DB_NAME;
    _database = await openDatabase(path, version: _VERSION, onCreate: (Database db, int version){});
  }
  // 判断表是否存在
  static Future<bool> isTableExists(String tableName) async {
    await getCurrentDataBase();
    var res = await _database.rawQuery("select * from Sqlite_master where type = 'table' and name = '$tableName'");
    return res.isNotEmpty;
  }
  // 获取当前数据库对象
  static Future<Database> getCurrentDataBase() async {
    await SqlManager.init();
    return _database;
  }
  // 插入
  Future<int> insert(Map<String, dynamic> values) async {
    return await _database.insert(_TABLE_NAME, values);
  }
  // 删除
  Future<int> delete(int id) async {
    return await _database.delete(_TABLE_NAME, where: '$_ID = ?', whereArgs: [id]);
  }
  // 更新
  Future<int> update(Map<String, dynamic> values) async {
    return await _database.update(_TABLE_NAME, values, where: '$_ID = ?', whereArgs: [values[_ID]]);
  }
  // 查询
  Future<List<Map<String, dynamic>>> queryAll() async {
    return await _database.query(_TABLE_NAME);
  }
  // 关闭
  Future close() async {
    await _database.close();
  }

}