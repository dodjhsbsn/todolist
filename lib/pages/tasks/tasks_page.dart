// 任务清单页面
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'tasks_controller.dart';
import '../../config/theme.dart';

class TasksPage extends StatelessWidget {
  // 任务页面标题
  final String title;
  TasksPage({super.key, required this.title});
  final TasksController _tasksController = Get.put(TasksController());
  // 判断是否为黑夜模式
  final RxBool isDarkModeValue = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
          // 控制drawer的按钮设置
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            }
          )
        ),
        body: _tasksController.buildReorderableColumn(),
        // 位于清单界面右下角的添加任务按钮
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _tasksController.showEditForm(null);
          },
          tooltip: '添加',
          child: const Icon(Icons.add),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SizedBox(
                height: 150.0,
                // drawer 头设置
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: isDarkModeValue.value? const Color.fromARGB(55, 255, 217, 70):const Color.fromARGB(255, 255, 217, 70),
                  ),
                  child: ListTile(
                    title:const Text('设置',style: TextStyle(fontSize: 20, ),),
                    subtitle: const Text('Settings',style: TextStyle(fontSize: 16,)),
                    visualDensity: VisualDensity.comfortable,
                    trailing: isDarkModeValue.value ?const Icon(Icons.nightlight_round):const Icon(Icons.wb_sunny),
                  ),
                ),
              ),
              // drawer items1 黑夜模式
              ListTile(
                title: const Text('黑夜模式'),
                trailing: Obx(() {
                  return Switch(
                    value: isDarkModeValue.value,
                    onChanged: (value) {
                      isDarkModeValue.value = !isDarkModeValue.value;
                      Get.changeTheme(isDarkModeValue.value ? Themes.dark : Themes.yellow);
                    },
                  );
                })
              ),
              // drawer items2
              ListTile(
                title: const Text('Item 2'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
