import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DatePicker{

  RxInt selectedYear =DateTime.now().year.obs;
  RxInt selectedMonth = DateTime.now().month.obs;

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  DatePicker.yearMonthPicker(){
    Get.dialog(
    );
  }
}
