import 'package:flutter/material.dart';
import 'database/sql_helper.dart';
import 'package:reorderables/reorderables.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _journals = [];
  // bool _isLoading = true;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshJournals();
  }

  void _refreshJournals() async {
    final data = await SQLHelper.getTasks();
    setState(() {
      _journals = List.from(data);
      // _isLoading = false;
    });
  }

  void showForm(int? id) async {
    if (id != null) {
      final data = _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = data['columnTitle'];
      _descriptionController.text = data['columnDescription'];
    }
    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 120,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '标题',
                ),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: '内容',
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
                      Navigator.of(context).pop();
                    },
                    child: const Text('取消'),
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
                      print('number of journals: ${_journals.length+1}');
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                    },
                    child: Text(id != null ? '更新' : '添加'),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  ReorderableColumn _buildReorderableColumn() {
    return ReorderableColumn(
        onReorder: _onReorder,
        children: _journals.map((task) => InkWell(
                  key: ValueKey(task['id']),
                  onTap: () {
                    SQLHelper.changeStatus(
                        task['id'], task['columnStatus'] == 1 ? 0 : 1);
                    _refreshJournals();
                  },
                  child: _buildTask(task),
                ))
            .toList());
  }

  Widget _buildTask(Map<String, dynamic> task) {
    return Card(
      child: ListTile(
        key: ValueKey(task['id']),
        title: Text(task['columnTitle'],
            style: TextStyle(
              decoration:
                  task['columnStatus'] == 1 ? TextDecoration.lineThrough : null,
              color: task['columnStatus'] == 1 ? Colors.grey : null,
            )),
        subtitle: Text(task['columnDescription'],
            style: TextStyle(
              color: task['columnStatus'] == 1 ? Colors.grey : null,
            )),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  showForm(task['id']);
                  _refreshJournals();
                },
              ),
              IconButton(
                onPressed: () async {
                  return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('删除'),
                        content: const Text('确定要删除吗？'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('取消'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await SQLHelper.deleteTask(task['id']);
                              _refreshJournals();
                              Navigator.of(context).pop();
                            },
                            child: const Text('确定'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ),
    );
  }



  void _onReorder(int oldIndex, int newIndex){
    setState(() {
      final task = _journals.removeAt(oldIndex);
      _journals.insert(newIndex, task);
    });
    // update database
    for (int i = 0; i < _journals.length; i++) {
      SQLHelper.updateTask(
        _journals[i]['id'],
        _journals[i]['columnTitle'],
        _journals[i]['columnDescription'],
      );
    }
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
            showForm(null);
          },
          tooltip: '添加',
          child: const Icon(Icons.add),
        ));
  }
}
