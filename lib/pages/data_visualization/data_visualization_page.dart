// 数据可视化页面
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todolist/model/date_picker.dart';
import 'data_visualization_controller.dart';

class DataVisualizationPage extends StatelessWidget {
  final String title;
  const DataVisualizationPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataVisualizationController = Get.put(DataVisualizationController());
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return Text('$title-${dataVisualizationController.currentYear.value}');
        }),
        actions: [
          IconButton(
            onPressed: () async{
              // 年月选择器
              Map<String,RxInt> argument = await DatePicker().yearMonthPicker();
              dataVisualizationController.currentYear.value = argument['year']!.value;
              dataVisualizationController.currentMonth.value = argument['month']!.value;
              debugPrint('year: ${dataVisualizationController.currentYear.value}, month: ${dataVisualizationController.currentMonth.value}');
            },
            icon: const Icon(Icons.calendar_today),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ListTile(
              //   title: Obx(() {
              //     return Text('${dataVisualizationController.currentMonth.value}月任务创建统计',style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),);
              //   }),
              //   subtitle: const Text('Task Create Time'),
              // ),
              DropdownButtonHideUnderline(
              child: DropdownButton(
                value: 0,
                items: [
                  DropdownMenuItem(
                    value: 0,
                    child: Obx(() {
                      return Text('${dataVisualizationController.currentMonth.value}月任务创建统计',style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),);
                    }),
                  ),
                  DropdownMenuItem(
                    value: 1,
                    child: Obx(() {
                      return Text('${dataVisualizationController.currentMonth.value}月任务完成统计',style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),);
                    }),
                  ),
                ],
                onChanged: (value) {
                  switch (value) {
                    case 0:
                      dataVisualizationController.mode.value = 'createTime';
                      break;
                    case 1:
                      dataVisualizationController.mode.value = 'finishedTime';
                      break;
                    default:
                  }
                },
              ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: const EdgeInsets.only(top: 16, bottom: 30, right: 16),
                  width: Get.width*2,
                  height: Get.height * 0.7,
                  child: AspectRatio(
                    aspectRatio: 1.7,
                    child: Obx(() {
                      return dataVisualizationController.buildBarChart(dataVisualizationController.mode.value);
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
