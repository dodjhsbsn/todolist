import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_item.dart';
import 'package:sqflite/sqflite.dart';


class TextController extends GetxController {
  final TextEditingController contentController = TextEditingController();
  RxList<Task> taskList = <Task>[].obs;

  @override
  void onClose() {
    super.onClose();
    contentController.dispose();
  }

  void taskFinished(task) {
    taskList[taskList.indexOf(task)].isDone.value = !taskList[taskList.indexOf(task)].isDone.value;
  }
  void addItem(String content) {
    Task task = Task();
    task.content = content;
    task.index = (taskList.length+1).toString();
    taskList.add(task);
  }
  void deleteItem(Task task) async{
    taskList.remove(task);
  }
  void deleteAllItem(){
    taskList.clear();
  }

}