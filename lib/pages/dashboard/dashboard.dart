// 控制面板
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:get/get.dart';
import '../../model/dialog.dart';
import 'package:todolist/pages/tasks/tasks_page.dart';
import '../data_visualization/data_visualization_page.dart';


class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});
  // bottomNavigationBar 索引
  final RxInt currentIndex = 0.obs;
  // bottomNavigationBar 选项
  final List<SalomonBottomBarItem> bottomBarItems = [
    SalomonBottomBarItem(
      icon: const Icon(Icons.home),
      title: const Text('清单'),
      selectedColor: Colors.yellow[800],
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.data_thresholding),
      title: const Text('数据'),
      selectedColor: Colors.blue,
    ),
  ];
  // bottomNavigationBar 页面
  final List<Widget> bottomBarPages = [
    TasksPage(title: '行动清单'),
    const DataVisualizationPage(title: '数据'),
  ];
  @override
  Widget build(BuildContext context) {
    DateTime? lastPopTime;
      return Obx(() {
        return WillPopScope(
            child: Scaffold(
                body: bottomBarPages[currentIndex.value],
                bottomNavigationBar: SalomonBottomBar(
                  currentIndex: currentIndex.value,
                  onTap: (index) {
                    currentIndex.value = index;
                  },
                  items: bottomBarItems,
                ),
            ),
            onWillPop: () async {
              // 点击返回键的操作
              if (lastPopTime == null ||
                  DateTime.now().difference(lastPopTime!) >
                      const Duration(seconds: 2)) {
                lastPopTime = DateTime.now();
                // 弹出提示
                DialogPop.toast('再按一次退出');
              } else {
                lastPopTime = DateTime.now();
                // 退出app
                await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              }
              throw 1;
            });
      });
    }
}