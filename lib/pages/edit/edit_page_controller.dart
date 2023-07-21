import 'package:flutter/material.dart';
import 'package:get/get.dart';


class EditPageController extends GetxController {
  // 任务卡编辑框标题和内容控制器
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  // 任务卡编辑框焦点控制器
  final FocusScopeNode node = FocusScopeNode();

  @override
  void onClose() {
    titleController.clear();
    descriptionController.clear();
    super.onClose();
  }

}