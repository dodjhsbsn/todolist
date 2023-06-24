import 'package:flutter/material.dart';
import 'database/sql_helper.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String,dynamic>> _journals = [];
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
      _journals = data;
      // _isLoading = false;
    });
  }
  void showForm(int? id) async{
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
            bottom: MediaQuery.of(context).viewInsets.bottom+120,
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
              const SizedBox(height: 16,),
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
                      } else {
                        await SQLHelper.createTask(
                          _titleController.text,
                          _descriptionController.text,
                        );
                      }
                      _titleController.clear();
                      _descriptionController.clear();
                      _refreshJournals();
                      print('number of journals: ${_journals.length}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView.builder(
          itemExtent: 80,
          itemCount: _journals.length,
          itemBuilder: (context,index) {
            return Card(
              child: ListTile(
                title: Text(_journals[index]['columnTitle']),
                subtitle: Text(_journals[index]['columnDescription']),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children:[
                      IconButton(
                        onPressed: () {
                          showForm(_journals[index]['id']);
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () async {
                          showDialog(
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
                                      Navigator.of(context).pop();
                                      await SQLHelper.deleteTask(_journals[index]['id']);
                                      _refreshJournals();
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
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showForm(null);
          },
          tooltip: '添加',
          child: const Icon(Icons.add),
        )
    );
  }
}
