// 主题配置
import 'package:flutter/material.dart';


class Themes {
  static final green = ThemeData.light().copyWith(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.green,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.green,
    ),
  );

  static final yellow = ThemeData.light().copyWith(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
  );

  static final red = ThemeData.light().copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.red,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.red,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.brown))));

  static final black = ThemeData.light().copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.brown))));

  static final white = ThemeData.light().copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.brown))));

  static final dark = ThemeData.dark().copyWith(
    useMaterial3: true,
    textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'Open Sans',
        ),
    switchTheme: ThemeData.dark().switchTheme.copyWith(
          trackColor: MaterialStateProperty.all(ColorScheme.fromSeed(seedColor: Colors.yellow).primary),
        ),
    floatingActionButtonTheme: ThemeData.dark().floatingActionButtonTheme.copyWith(
          backgroundColor: ColorScheme.fromSeed(seedColor: Colors.yellow).primary,
        ),
    appBarTheme: AppBarTheme(
      backgroundColor: ThemeData.dark().scaffoldBackgroundColor,
    ),
  );

  static final blue = ThemeData.light().copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.blue,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.brown))));
}
