import 'package:flutter/material.dart';
import 'package:simple_chat/utils/color.dart';

class TChipTheme {
  TChipTheme._();

  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: Colors.grey.withOpacity(0.4),
    labelStyle: const TextStyle(fontSize: 24, color: Colors.black),
    selectedColor: AppColors.floatingActionButtonColor,
    padding: const EdgeInsets.all(10),
    checkmarkColor: Colors.white,
  );

  static ChipThemeData darkChipTheme = ChipThemeData(
    disabledColor: Colors.grey.withOpacity(0.4),
    labelStyle: const TextStyle(fontSize: 24, color: Colors.black),
    selectedColor: AppColors.floatingActionButtonColor,
    padding: const EdgeInsets.all(10),
    checkmarkColor: Colors.white,
  );
}