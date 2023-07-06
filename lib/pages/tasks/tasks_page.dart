// 任务清单页面
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'tasks_controller.dart';

class TasksPage extends StatelessWidget {
  final String title;
  TasksPage({super.key, required this.title});
  final TasksController _tasksController = Get.put(TasksController());


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: _tasksController.buildReorderableColumn(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _tasksController.showEditForm(null);
          },
          tooltip: '添加',
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}
