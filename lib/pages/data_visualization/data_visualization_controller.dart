// 数据可视化页面控制器
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import '../tasks/tasks_controller.dart';

class DataVisualizationController extends GetxController {
  final tasksController = Get.put(TasksController());
  RxInt currentMonth = DateTime.now().month.obs;
  RxInt currentYear = DateTime.now().year.obs;
  final RxString mode = 'createTime'.obs;

  // 柱状图颜色混合调色盘
  LinearGradient _barsGradient(String mode) {
    if (mode == 'createTime') {
      return const LinearGradient(
        colors: [
          Colors.yellow,
          Colors.green,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );
    }
    if (mode == 'finishedTime') {
      return const LinearGradient(
        colors: [
          Colors.pinkAccent,
          Colors.greenAccent,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );
    } else {
      return const LinearGradient(colors: [Colors.white, Colors.white]);
    }
  }

  // 对任务创建或任务完成在星期几进行统计
  getSumTasksByWeek(String mode) {
    final List<int> sumTasksByWeek = [];
    if (mode == 'createTime') {
      for (int i = 0; i < 7; i++) {
        sumTasksByWeek.add(tasksController.journals
            .where((element) => element['createWeek'] == i)
            .length);
      }
    }
    if (mode == 'finishedTime') {
      for (int i = 0; i < 7; i++) {
        sumTasksByWeek.add(tasksController.journals
            .where((element) => element['finishedWeek'] == i)
            .length);
      }
    }
    return sumTasksByWeek;
  }

  // 按年月筛选
  filterByYearMonth(String mode, int year, int month) {
    final List<int> sumTasksByYearMonth = [];
    if (mode == 'createTime') {
      for (int i = 1; i < 32; i++) {
        sumTasksByYearMonth.add(tasksController.journals
            .where((element) =>
                DateTime.parse(element['createTime']).day == i &&
                DateTime.parse(element['createTime']).year == year &&
                DateTime.parse(element['createTime']).month == month)
            .length);
      }
    }
    if (mode == 'finishedTime') {
      for (int i = 1; i < 32; i++) {
        sumTasksByYearMonth.add(tasksController.journals.where((element) {
          if (element['finishedTime'] != null) {
            return DateTime.parse(element['finishedTime']).day == i &&
                DateTime.parse(element['finishedTime']).year == year &&
                DateTime.parse(element['finishedTime']).month == month;
          } else {
            return false;
          }
        }).length);
      }
    }
    return sumTasksByYearMonth;
  }

  // 左轴标题
  Widget getLeftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0';
        break;
      case 5:
        text = '5';
        break;
      case 10:
        text = '10';
        break;
      case 15:
        text = '15';
        break;
      case 20:
        text = '20';
        break;
      case 25:
        text = '25';
        break;
      case 30:
        text = '30';
        break;
      case 35:
        text = '35';
        break;
      case 40:
        text = '40';
        break;
      default:
        return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  // 柱状图内容
  List<BarChartGroupData> barGroups(String mode) => [
        for (int i = 0; i < 31; i++)
          BarChartGroupData(
            x: i + 1,
            barRods: [
              BarChartRodData(
                toY: filterByYearMonth(
                        mode, currentYear.value, currentMonth.value)[i]
                    .toDouble(),
                gradient: _barsGradient(mode),
              )
            ],
            showingTooltipIndicators: filterByYearMonth(
                            mode, currentYear.value, currentMonth.value)[i]
                        .toDouble() !=
                    0
                ? [0]
                : [],
          ),
      ];

  // 柱状图轴属性
  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getLeftTitles,
            interval: 1,
            reservedSize: 22,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  // 柱状图框属性
  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  // 柱状图点击属性
  BarTouchData get barTouchData => BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.cyan,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  // 柱状图创建函数
  buildBarChart(mode) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups(mode),
        gridData: FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: 40,
        minY: 0,
      ),
      swapAnimationDuration: const Duration(milliseconds: 250),
      swapAnimationCurve: Curves.easeInOut,
    );
  }
}
