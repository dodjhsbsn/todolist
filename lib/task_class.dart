
class Task {
  final int id;
  final String columnTitle;
  final String columnDescription;
  final int columnStatus;
  final int orderIndex;
  final String createTime;

  Task({
    required this.id,
    required this.columnTitle,
    required this.columnDescription,
    required this.columnStatus,
    required this.orderIndex,
    required this.createTime,
  });
}

