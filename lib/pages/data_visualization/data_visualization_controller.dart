import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import '../tasks/tasks_controller.dart';


class DataVisualizationController extends GetxController{
  final tasksController = Get.put(TasksController());
  List<Color> gradientColors = [
    Colors.yellow,
    Colors.cyan,
  ];

  getDataSpots(){
    List<FlSpot> spots = [];
    for(int i = 0; i < tasksController.journals.length; i++){
      // parse the createTime to DateTime
      DateTime createTime = DateTime.parse(tasksController.journals[i]['createTime']);
      // get the month-day-minute
      var month = createTime.month;
      var day = createTime.day;
      var minute = createTime.minute;
      // get the sum of the month-day-minute
      var sum = month+day+minute;
      // add the spot to the list
      spots.add(FlSpot(sum.toDouble(), i.toDouble()));
    }
    return spots;
  }
  Widget buildLineChart(){
    return LineChart(
      mainData()
    );
  }
  LineChartData mainData(){
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.amber,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.green,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 1),
            FlSpot(1, 1),
            FlSpot(3, 4),
            FlSpot(5, 1.8),
            FlSpot(7, 5),
            FlSpot(10, 2),
            FlSpot(11, 2.2),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('三月', style: style);
        break;
      case 5:
        text = const Text('六月', style: style);
        break;
      case 8:
        text = const Text('九月', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10';
        break;
      case 3:
        text = '20';
        break;
      case 5:
        text = '30';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }
}