// 数据可视化页面控制器
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import '../tasks/tasks_controller.dart';


class DataVisualizationController extends GetxController{
  final tasksController = Get.put(TasksController());

  // 柱状图颜色混合器
  LinearGradient _barsGradient(String mode){
    if (mode == 'createTime'){
      return const LinearGradient(
        colors: [
          Colors.yellow,
          Colors.green,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );
    }if (mode == 'finishedTime'){
      return const LinearGradient(
        colors: [
          Colors.pinkAccent,
          Colors.greenAccent,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );
    }else{
      return const LinearGradient(colors: [Colors.white, Colors.white]);
    }
  }

  // 对任务创建或任务完成在星期几进行统计
  getSumTasksByWeek(String mode) {
    final List<int> sumTasksByWeek = [];
    if (mode == 'createTime'){
      for (int i = 0; i < 7; i++) {
        sumTasksByWeek.add(tasksController.journals.where((element) => element['createWeek'] == i).length);
      }
    }if (mode == 'finishedTime'){
      for (int i = 0; i < 7; i++) {
        sumTasksByWeek.add(tasksController.journals.where((element) => element['finishedWeek'] == i).length);
      }
    }
    return sumTasksByWeek;
  }

  // 轴标题
  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Mn';
        break;
      case 1:
        text = 'Te';
        break;
      case 2:
        text = 'Wd';
        break;
      case 3:
        text = 'Tu';
        break;
      case 4:
        text = 'Fr';
        break;
      case 5:
        text = 'St';
        break;
      case 6:
        text = 'Sn';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  // 柱状图内容
  List<BarChartGroupData> barGroups(String mode) => [
    BarChartGroupData(
      x: 0,
      barRods: [
        BarChartRodData(
          toY: getSumTasksByWeek(mode)[1].toDouble(),
          gradient: _barsGradient(mode),
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 1,
      barRods: [
        BarChartRodData(
          toY: getSumTasksByWeek(mode)[2].toDouble(),
          gradient: _barsGradient(mode),
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 2,
      barRods: [
        BarChartRodData(
          toY: getSumTasksByWeek(mode)[3].toDouble(),
          gradient: _barsGradient(mode),
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 3,
      barRods: [
        BarChartRodData(
          toY: getSumTasksByWeek(mode)[4].toDouble(),
          gradient: _barsGradient(mode),
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 4,
      barRods: [
        BarChartRodData(
          toY: getSumTasksByWeek(mode)[5].toDouble(),
          gradient: _barsGradient(mode),
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 5,
      barRods: [
        BarChartRodData(
          toY: getSumTasksByWeek(mode)[6].toDouble(),
          gradient: _barsGradient(mode),
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 6,
      barRods: [
        BarChartRodData(
          toY: getSumTasksByWeek(mode)[0].toDouble(),
          gradient: _barsGradient(mode),
        )
      ],
      showingTooltipIndicators: [0],
    ),
  ];

  // 柱状图轴属性
  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: getTitles,
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
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
  buildBarChart(mode){
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups(mode),
        gridData: FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
      ),
      swapAnimationDuration: const Duration(milliseconds: 250),
      swapAnimationCurve: Curves.easeInOut,
    );
  }
}