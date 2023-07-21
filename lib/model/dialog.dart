// 弹出提示框
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class DialogPop {
  // toast弹出提示框
  DialogPop.toast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      // 保持时间，针对安卓
      toastLength: Toast.LENGTH_SHORT,
      // 调整方位
      gravity: ToastGravity.CENTER,
      // 保持时间，针对ios和web
      timeInSecForIosWeb: 1,
      // 颜色和字体
      backgroundColor: const Color.fromARGB(255, 255, 217, 70),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
