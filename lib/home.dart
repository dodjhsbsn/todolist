import 'package:flutter/material.dart';
import 'database/sql_helper.dart';
import 'package:reorderables/reorderables.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 任务列表
  List<Map<String, dynamic>> _journals = [];
  // 任务卡编辑框标题和内容控制器
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  // 任务卡编辑框焦点控制器
  FocusScopeNode node = FocusScopeNode();

  @override
  void initState() {
    super.initState();
    _refreshJournals();
  }

  // 刷新任务列表
  void _refreshJournals() async {
    final data = await SQLHelper.getTasks();
    setState(() {
      _journals = List<Map<String, dynamic>>.from(data);
    });
  }

  // 显示任务卡编辑框
  void showEditForm(int? id) async {
    if (id != null) {
      final data = _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = data['columnTitle'];
      _descriptionController.text = data['columnDescription'];
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Container(
            padding: EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 50,
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
                          _refreshJournals();
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
                          '创建时间：${DateFormat('yyyy-MM-dd').format(DateTime.parse(_journals.firstWhere((element) => element['id'] == id)['createTime']))}',
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
    );
  }

  ReorderableColumn _buildReorderableColumn() {
    return ReorderableColumn(
      footer: TextButton(
        onPressed: () {
          SQLHelper.deleteAll();
        },
        child: const Text('delete database'),
      ),
      onReorder: _onReorder,
      children: _journals.map<Widget>((task) {
        return ReorderableWidget(
          key: ValueKey(task['id']),
          reorderable: true,
          child: InkWell(
            onTap: () {
              SQLHelper.changeStatus(
                task['id'],
                task['columnStatus'] == 1 ? 0 : 1,
              );
              _refreshJournals();
            },
            child: _buildTask(task),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTask(Map<String, dynamic> task) {
    final bool isCompleted = task['columnStatus'] == 1;

    return Card(
      child: ListTile(
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
                  _refreshJournals();
                },
              ),
              IconButton(
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
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
                      );
                    },
                  );

                  if (confirmed == true) {
                    await SQLHelper.deleteTask(task['id']);
                    _refreshJournals();
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
    final oldTask = _journals[oldIndex];
    final newTask = _journals[newIndex];
    // 更新_journals数据，移除旧位置任务，插入新位置任务
    setState(() {
      _journals.removeAt(oldIndex);
      _journals.insert(newIndex, oldTask);
    });

    await SQLHelper.updateTaskOrder(
      oldTask['id'],
      newTask['id'],
      oldTask['columnTitle'],
      oldTask['columnDescription'],
      oldTask['columnStatus'],
    );
    debugPrint('reorder: ${oldTask['id']} -> ${newTask['id']}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: _buildReorderableColumn(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showEditForm(null);
          },
          tooltip: '添加',
          child: const Icon(Icons.add),
        ));
  }
}
