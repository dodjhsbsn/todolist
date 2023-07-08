// 主程序入口
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routers/routers.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.yellow,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      getPages: Routers.pages,
      initialRoute: '/',
    );
  }
}
