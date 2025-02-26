import 'package:flutter/material.dart';
import 'package:simple_chat/utils/color.dart';

class TFloatingButtonTheme {
  TFloatingButtonTheme._();

  static FloatingActionButtonThemeData lightFloatingButtonTheme = const FloatingActionButtonThemeData(
    elevation: 0,
    foregroundColor: Colors.white,
    backgroundColor: AppColors.floatingActionButtonColor,
    shape: CircleBorder(),
  );

  static FloatingActionButtonThemeData darkFloatingButtonTheme = const FloatingActionButtonThemeData(
    elevation: 0,
    foregroundColor: Colors.white,
    backgroundColor: AppColors.floatingActionButtonColor,
    shape: CircleBorder(),
  );
}