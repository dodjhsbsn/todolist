import '../sql_manager.dart';
import 'package:sqflite/sqlite_api.dart';

abstract class BaseTableProvider{
  String tableName();
  String createTableString();

  // 获取数据库
  Future<Database> getDataBase() async{
    bool isTableExists = await SqlManager.isTableExists(tableName());
    if(!isTableExists){
      Database db = await SqlManager.getCurrentDataBase();
      await db.execute(createTableString());
      return db;
    }else{
      return await SqlManager.getCurrentDataBase();
    }
  }
  // 创建表
  Future createTable() async{
    bool isTableExists = await SqlManager.isTableExists(tableName());
    if(!isTableExists){
      Database db = await SqlManager.getCurrentDataBase();
      await db.execute(createTableString());
    }
  }
}