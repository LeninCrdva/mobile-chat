import 'package:flutter/material.dart';
import 'package:simple_chat/utils/color.dart';
import 'package:simple_chat/utils/theme/custom_theme/app_bar_theme.dart';
import 'package:simple_chat/utils/theme/custom_theme/bottom_navigation_theme.dart';
import 'package:simple_chat/utils/theme/custom_theme/chip_theme.dart';
import 'package:simple_chat/utils/theme/custom_theme/elevated_button_theme.dart';
import 'package:simple_chat/utils/theme/custom_theme/floating_button_theme.dart';
import 'package:simple_chat/utils/theme/custom_theme/switch_theme.dart';
import 'package:simple_chat/utils/theme/custom_theme/text_theme.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Poppins',
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  chipTheme: TChipTheme.lightChipTheme,
  textTheme: TTextTheme.lightTextTheme,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: TAppBarTheme.lightAppBarTheme,
  switchTheme: TSwitchTheme.lightSwitchTheme,
  elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
  floatingActionButtonTheme: TFloatingButtonTheme.lightFloatingButtonTheme,
  bottomNavigationBarTheme: TBottomNavigationTheme.lightBottomNavigationTheme,
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Poppins',
  brightness: Brightness.dark,
  chipTheme: TChipTheme.darkChipTheme,
  textTheme: TTextTheme.darkTextTheme,
  primaryColor: AppColors.darkPrimaryColor,
  appBarTheme: TAppBarTheme.darkAppBarTheme,
  switchTheme: TSwitchTheme.darkSwitchTheme,
  scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
  elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
  floatingActionButtonTheme: TFloatingButtonTheme.lightFloatingButtonTheme,
  bottomNavigationBarTheme: TBottomNavigationTheme.darkBottomNavigationTheme,
);
