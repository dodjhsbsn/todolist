// 任务卡控制器，包括任务卡编辑框的控制器
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reorderables/reorderables.dart';
import '../../database/sql_helper.dart';


class TasksController extends GetxController{
  // 任务卡编辑框标题和内容控制器
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  // 任务卡编辑框焦点控制器
  FocusScopeNode node = FocusScopeNode();
  // 判断是否为黑夜模式
  final RxBool isDarkModeValue = false.obs;
  // 任务列表
  final journals = [].obs;

  @override
  void onInit() {
    refreshJournals();
    super.onInit();
  }
  @override
  void onClose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.onClose();
  }
  // 刷新任务列表
  void refreshJournals() async {
    final data = await SQLHelper.getTasks();
    journals.value = List.from(data);
  }

  // 显示任务卡编辑框
  void showEditForm(int? id) async {
    if (id != null) {
      final data = journals.firstWhere((element) => element['id'] == id);
      _titleController.text = data['columnTitle'];
      _descriptionController.text = data['columnDescription'];
    }
    showModalBottomSheet(
      context: Get.context!,
      builder: (BuildContext context) {
        return Container(
            padding: EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
              bottom: MediaQuery
                  .of(Get.context!)
                  .viewInsets
                  .bottom + 50,
            ),
            child: FocusScope(
              node: node,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: '标题',
                      prefixIcon: Icon(Icons.title),
                    ),
                    maxLines: 1,
                    maxLength: 20,
                    // 输入框焦点控制
                    onEditingComplete: () {
                      node.nextFocus();
                    },
                    onTapOutside: (PointerDownEvent event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                  ),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    maxLength: 150,
                    decoration: const InputDecoration(
                      labelText: '内容',
                      prefixIcon: Icon(
                        Icons.description,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text('取消'),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (id != null) {
                            await SQLHelper.updateTask(
                              id,
                              _titleController.text,
                              _descriptionController.text,
                            );
                          } else if (_titleController.text.isNotEmpty) {
                            await SQLHelper.createTask(
                              _titleController.text,
                              _descriptionController.text,
                            );
                          }
                          _titleController.clear();
                          _descriptionController.clear();
                          refreshJournals();
                          Get.back();
                        },
                        child: Text(id != null ? '更新' : '添加'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  // 显示格式化任务创建时间
                  if (id != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '创建时间：${DateFormat('yyyy-MM-dd').format(
                              DateTime.parse(journals.firstWhere((element) =>
                              element['id'] == id)['createTime']))}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ));
      },
      isScrollControlled: true,
    );
  }

  // 建立可拖动的任务列表
  ReorderableColumn buildReorderableColumn() {
    return ReorderableColumn(
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
          icon: Icon(isCompleted ? Icons.check_circle : Icons.radio_button_unchecked),
          color: isCompleted ? Colors.grey : null,),
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
                  final confirmed = await Get.dialog<bool>(
                      AlertDialog(
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
                      )
                  );

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

}