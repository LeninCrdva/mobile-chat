import 'package:flutter/material.dart';
import 'package:simple_chat/utils/color.dart';

class TSwitchTheme {
  TSwitchTheme._();

  static SwitchThemeData lightSwitchTheme = SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.disabled)) {
        return Colors.grey;
      }
      return AppColors.floatingActionButtonColor.withOpacity(0.5);
    }),
    trackColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.disabled)) {
        return Colors.grey.withOpacity(0.5);
      }
      return AppColors.floatingActionButtonColor.withOpacity(0.2);
    }),
  );

  static SwitchThemeData darkSwitchTheme = SwitchThemeData(
    thumbColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.disabled)) {
        return Colors.grey;
      }
      return AppColors.floatingActionButtonColor.withOpacity(0.5);
    }),
    trackColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.disabled)) {
        return Colors.grey.withOpacity(0.5);
      }
      return AppColors.floatingActionButtonColor.withOpacity(0.2);
    }),
  );
}
