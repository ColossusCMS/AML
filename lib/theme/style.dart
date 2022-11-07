import 'package:flutter/material.dart';
import 'package:aml/theme/custom_themes.dart';

class CustomTheme {
  static ThemeData light() {
    return ThemeData(
        appBarTheme: AppBarTheme(
          color: Color(0xFF6750A4),
          elevation: 2.0,
          shadowColor: Color(0xFF625B71),
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            color: Color(0xFFFFD8E4),
          ),
          iconTheme: IconThemeData(
            color: Color(0xFFFFD8E4),
          ),
          actionsIconTheme: IconThemeData(
            color: Color(0xFFFFD8E4),
          ),
        ),
        primaryColor: Color(0xFF6750A4),
        textTheme: TextTheme(
          bodyText1: TextStyle(
            color: Color(0xFF625B71),
            decoration: TextDecoration.underline,
            fontSize: 18,
          ),
          bodyText2: TextStyle(
            color: Color(0xFF625B71),
            decoration: TextDecoration.underline,
            fontSize: 14,
          ),
        ),
        listTileTheme: ListTileThemeData(
          textColor: Color(0xFF625B71),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: CustomColors.backgroundColor,
          foregroundColor: CustomColors.foregroundColor,
        )
    );
  }

  static ThemeData dark() {
    return ThemeData(
        appBarTheme: AppBarTheme(
          color: Color(0xFF6750A4),
          elevation: 2.0,
          shadowColor: Color(0xFF625B71),
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            color: Color(0xFFFFD8E4),
          ),
          iconTheme: IconThemeData(
            color: Color(0xFFFFD8E4),
          ),
          actionsIconTheme: IconThemeData(
            color: Color(0xFFFFD8E4),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: CustomColors.backgroundColor,
          foregroundColor: CustomColors.foregroundColor,
        )
    );
  }
}