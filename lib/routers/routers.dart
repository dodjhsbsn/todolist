// 路由管理
import 'package:get/get.dart';
import '/pages/data_visualization/data_visualization_page.dart';
import '../pages/dashboard/dashboard.dart';
import '/pages/tasks/tasks_page.dart';

class Routers {
  static final List<GetPage> pages = [
    GetPage(
      name: '/',
      page: () => DashboardPage(),
    ),
    GetPage(
      name: '/tasks',
      page: () => TasksPage(title: '行动清单'),
    ),
    GetPage(
      name: '/data_visualization',
      page: () => const DataVisualizationPage(title: '数据'),
    ),
  ];
}
