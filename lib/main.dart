import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home.dart';
import 'database/providers/task_table_provider.dart';
import 'database/providers/base_table_provider.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _createTable();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(title: '行动清单'),
    );
  }
}

void _createTable() async {
  TaskTableProvider taskTableProvider = TaskTableProvider();
  await taskTableProvider.createTable();
}