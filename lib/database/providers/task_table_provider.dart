import 'base_table_provider.dart';


class TaskTableProvider extends BaseTableProvider{
  final String tablename = 'task';

  // 表字段
  final String columnId = 'id';
  final String columnContent = 'content';
  final String columnIsDone = 'isDone';

  @override
  String createTableString() {
    return '''
    CREATE TABLE $tablename (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnContent TEXT NOT NULL,
      $columnIsDone INTEGER NOT NULL
    )
    ''';
  }

  @override
  String tableName() {
    return tablename;
  }

}