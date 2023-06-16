import 'package:flutter/material.dart';
import 'text_controller.dart';
import 'package:get/get.dart';


class HomePage extends StatelessWidget {
  HomePage({super.key, required this.title});
  final TextController _controller = Get.put(TextController());
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Obx(() {
              return ListView(
                itemExtent: 70,
                children: _controller.taskList.map((task) {
                  return InkWell(
                    onTap: () {
                      _controller.taskFinished(task);
                    },
                    child: Card(
                      child: ListTile(
                        leading: Text(task.index,style: const TextStyle(fontSize: 20),),
                        title: Text(task.content,style: const TextStyle(fontSize: 15),),
                        titleTextStyle: TextStyle(
                          decoration: task.isDone.value ? TextDecoration.lineThrough : null,
                          decorationThickness: 5,
                          color: Colors.black,
                        ),
                        /*
                  删除条目的按钮
                   */
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('删除条目'),
                                    content: const Text('确定要删除这个条目吗？'),
                                    actions: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('取消')),
                                          TextButton(
                                              onPressed: () {
                                                _controller.deleteItem(task);
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('确定')),
                                        ],
                                      ),
                                    ],
                                  );
                                }
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
          ),
          Positioned(
            bottom: 20,
            right: 80,
            child: IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('删除所有条目'),
                        content: const Text('确定要删除所有条目吗？'),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('取消')),
                              TextButton(
                                  onPressed: () {
                                    _controller.deleteAllItem();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('确定')),
                            ],
                          ),
                        ],
                      );
                    }
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('添加条目'),
                  actions: [
                    TextField(
                      controller: _controller.contentController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '内容',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('取消')),
                        TextButton(
                            onPressed: () {
                              if (_controller.contentController.text.isEmpty) {
                              } else {
                                _controller.addItem(_controller.contentController.text);
                                _controller.contentController.clear();
                              }
                              Navigator.of(context).pop();
                            },
                            child: const Text('确定')),
                      ],
                    ),
                  ],
                );
              });
        },
        tooltip: '添加条目',
        child: const Icon(Icons.add),
      ),
    );
  }
}
