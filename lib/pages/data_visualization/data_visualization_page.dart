// 数据可视化页面
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'data_visualization_controller.dart';


class DataVisualizationPage extends StatelessWidget {
  final String title;
  const DataVisualizationPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataVisualizationController = Get.put(DataVisualizationController());

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              title: Text('任务创建统计/月',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              subtitle: Text('Task Create Time'),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: const EdgeInsets.only(top: 16, bottom: 30, right: 16),
                  width: 700,
                  height: 240,
                  child: AspectRatio(
                    aspectRatio: 1.7,
                    child: dataVisualizationController.buildBarChart('createTime'),
                  ),
                ),
            ),
            const SizedBox(height: 16),
            const ListTile(
              title: Text('任务完成统计/月',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              subtitle: Text('Task finished Time'),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                padding: const EdgeInsets.only(top: 16, bottom: 30, right: 16),
                width: 700,
                height: 240,
                child: AspectRatio(
                  aspectRatio: 1.7,
                  child: dataVisualizationController.buildBarChart('finishedTime'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}