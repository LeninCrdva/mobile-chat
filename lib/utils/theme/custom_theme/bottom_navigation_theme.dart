import 'package:flutter/material.dart';
import 'package:simple_chat/utils/color.dart';

class TBottomNavigationTheme {
  TBottomNavigationTheme._();

  static BottomNavigationBarThemeData lightBottomNavigationTheme = const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: AppColors.selectedLightItem,
    unselectedItemColor: AppColors.unselectedLightItem,
  );

  static BottomNavigationBarThemeData darkBottomNavigationTheme = const BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.grey,
  );
}