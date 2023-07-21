import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../database/sql_helper.dart';
import '../tasks/tasks_controller.dart';
import 'edit_page_controller.dart';


class EditPage extends StatelessWidget {
  EditPage({
    super.key,
    this.id,
  });

  final TasksController tasksController = Get.find();
  final EditPageController editPageController = Get.put(EditPageController());
  // 任务id
  final int? id;

  @override
  Widget build(BuildContext context) {
    RxList journals = tasksController.journals;
    if (id != null) {
      final data = journals.firstWhere((element) => element['id'] == id);
      editPageController.titleController.text = data['columnTitle'];
      editPageController.descriptionController.text = data['columnDescription'];
    }
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('编辑任务'),
            actions: [
              IconButton(
                onPressed: () async {
                  if (id != null) {
                    // 如果id不为空，则更新任务
                    await SQLHelper.updateTask(
                      id!,
                      editPageController.titleController.text,
                      editPageController.descriptionController.text,
                    );
                    // 提示保存成功
                    Get.dialog(
                        const AlertDialog(
                          content: Text('保存成功'),
                        )
                    ).timeout(const Duration(seconds: 1), onTimeout: () {
                      Get.back();
                    });
                  } else if (editPageController.titleController.text.isNotEmpty) {
                    // 如果标题不为空，则创建任务
                    await SQLHelper.createTask(
                      editPageController.titleController.text,
                      editPageController.descriptionController.text,
                    );
                    // 提示保存成功
                    Get.dialog(
                        const AlertDialog(
                          content: Text('保存成功'),
                        )
                    ).timeout(const Duration(seconds: 1), onTimeout: () {
                      Get.back();
                    });
                  }else{
                    // 如果标题为空，则提示
                    Get.dialog(
                        const AlertDialog(
                          content: Text('标题不能为空'),
                        )
                    ).timeout(const Duration(seconds: 1), onTimeout: () {
                      Get.back();
                    });
                    return;
                  }

                },
                icon: const Icon(Icons.save),
              ),
            ],
            surfaceTintColor: Colors.white,
          ),
          body: Scrollbar(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                ),
                child: FocusScope(
                  node: editPageController.node,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextField(
                        controller: editPageController.titleController,
                        decoration: const InputDecoration(
                          hintText: '标题',
                          border: InputBorder.none,
                        ),
                        maxLines: 1,
                        maxLength: 20,
                        // 输入框焦点控制
                        onEditingComplete: () {
                          editPageController.node.nextFocus();
                        },
                        onTapOutside: (PointerDownEvent event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.calendar_today,
                          color: Color.fromARGB(255, 255, 217, 70),
                        ),
                        title: Text(
                          '今天 ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
                        ),
                        // 显示创建时间
                        trailing: id != null
                            ? Text(
                          '创建时间：${DateFormat('yyyy-MM-dd').format(DateTime.parse(journals.firstWhere((element) => element['id'] == id)['createTime']))}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        )
                            : null,
                      ),
                      SizedBox(
                        child: TextField(
                          controller: editPageController.descriptionController,
                          maxLines: 100,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          )),
      onWillPop: ()async{
        if (id != null) {
          // 如果id不为空，则更新任务
          await SQLHelper.updateTask(
            id!,
            editPageController.titleController.text,
            editPageController.descriptionController.text,
          );
          editPageController.titleController.clear();
          editPageController.descriptionController.clear();
          tasksController.refreshJournals();
        } else if (editPageController.titleController.text.isNotEmpty) {
          // 如果标题不为空，则创建任务
          await SQLHelper.createTask(
            editPageController.titleController.text,
            editPageController.descriptionController.text,
          );
          editPageController.titleController.clear();
          editPageController.descriptionController.clear();
          tasksController.refreshJournals();
        }
        return Future.value(true);
      },
    );
  }
}
