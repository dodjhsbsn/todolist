// 时间选择器
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DatePicker {
  RxInt selectedYear = DateTime.now().year.obs;
  RxInt selectedMonth = DateTime.now().month.obs;

  final List<String> months = [
    '一月',
    '二月',
    '三月',
    '四月',
    '五月',
    '六月',
    '七月',
    '八月',
    '九月',
    '十月',
    '十一月',
    '十二月',
  ];

  Future<Map<String, RxInt>> yearMonthPicker() async{
    Map<String,RxInt> argument;
    await Get.dialog(
      AlertDialog(
        title: const Text('选择年份和月份'),
        content: SizedBox(
          width: Get.width,
          height: Get.height / 3,
          child: Column(
            children: [
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (selectedYear.value > 2021) {
                          selectedYear.value -= 1;
                        }
                      },
                      icon: const Icon(Icons.arrow_left),
                    ),
                    TextButton(
                        onPressed: () {
                          // year picker
                        },
                        child: Text(selectedYear.value.toString())),
                    IconButton(
                      onPressed: () {
                        if (selectedYear.value < 2030) {
                          selectedYear.value += 1;
                        }
                      },
                      icon: const Icon(Icons.arrow_right),
                    ),
                  ],
                );
              }),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 4,
                  children: List.generate(12, (index) {
                    return TextButton(
                      onPressed: () {
                        selectedMonth.value = index + 1;
                        Get.back();
                      },
                      child: Text(months[index]),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    argument = {
      'year': selectedYear,
      'month': selectedMonth,
    };
    return Future.value(argument);
  }


}
