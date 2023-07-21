// 任务卡控制器，包括任务卡编辑框的控制器
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reorderables/reorderables.dart';
import '../../database/sql_helper.dart';
import '../edit/edit_page.dart';

class TasksController extends GetxController {
  // 判断是否为黑夜模式
  final RxBool isDarkModeValue = false.obs;
  // 任务列表
  final journals = [].obs;
  // 任务完成与未完成分类
  final RxList<Map<String, dynamic>> finishedTasks =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> unfinishedTasks =
      <Map<String, dynamic>>[].obs;
  // 任务卡编辑框焦点控制器
  final FocusScopeNode node = FocusScopeNode();

  @override
  void onInit() {
    refreshJournals();
    super.onInit();
  }

  // 刷新任务列表
  void refreshJournals() async {
    final data = await SQLHelper.getAllTasks();
    journals.value = List.from(data);
  }

  // 显示任务卡编辑页面
  showEditForm(int? id) async{
    await Get.to(() => EditPage(id: id));
  }

  // 建立可拖动的任务列表
  ReorderableColumn buildReorderableColumn() {
    return ReorderableColumn(
      padding: const EdgeInsets.only(bottom: 70),
      onReorder: _onReorder,
      children: journals.map<Widget>((task) {
        return ReorderableWidget(
          key: ValueKey(task['id']),
          reorderable: true,
          child: _buildTask(task),
        );
      }).toList(),
    );
  }

  // 建立任务列表
  Widget _buildTask(Map<String, dynamic> task) {
    final bool isCompleted = task['columnStatus'] == 1;

    return Card(
      child: ListTile(
        leading: IconButton(
          onPressed: () {
            SQLHelper.changeStatus(
              task['id'],
              task['columnStatus'] == 1 ? 0 : 1,
            );
            refreshJournals();
          },
          icon: Icon(
              isCompleted ? Icons.check_circle : Icons.radio_button_unchecked),
          color: isCompleted ? Colors.grey : null,
        ),
        key: ValueKey(task['id']),
        iconColor: isCompleted ? Colors.grey : null,
        minVerticalPadding: 16,
        title: Text(
          task['columnTitle'],
          softWrap: true,
          style: TextStyle(
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted ? Colors.grey : null,
            fontSize: 19,
          ),
        ),
        subtitle: Text(
          task['columnDescription'],
          // softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isCompleted ? Colors.grey : null,
            fontSize: 14,
          ),
        ),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  showEditForm(task['id']);
                  refreshJournals();
                },
              ),
              IconButton(
                onPressed: () async {
                  final confirmed = await Get.dialog<bool>(AlertDialog(
                    title: const Text('删除'),
                    content: const Text('确定要删除吗？'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back(result: false);
                        },
                        child: const Text('取消'),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back(result: true);
                        },
                        child: const Text('确定'),
                      ),
                    ],
                  ));

                  if (confirmed == true) {
                    await SQLHelper.deleteTask(task['id']);
                    refreshJournals();
                  }
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) async {
    final oldTask = journals[oldIndex];
    final newTask = journals[newIndex];
    // 更新journals数据，移除旧位置任务，插入新位置任务
    journals.removeAt(oldIndex);
    journals.insert(newIndex, oldTask);

    await SQLHelper.updateTaskOrder(
      oldTask['id'],
      newTask['id'],
      oldTask['columnTitle'],
      oldTask['columnDescription'],
      oldTask['columnStatus'],
    );
    debugPrint('reorder: ${oldTask['id']} -> ${newTask['id']}');
  }

  // 显示全部任务
  void showAllTasks() async {
    final result = await SQLHelper.getAllTasks();
    journals.value = result;
  }

  // 显示已完成任务
  void showFinishedTasks() async {
    final result = await SQLHelper.getFinishedTasks();
    journals.value = result;
  }

  // 显示未完成任务
  void showUnfinishedTasks() async {
    final result = await SQLHelper.getUnfinishedTasks();
    journals.value = result;
  }
}
