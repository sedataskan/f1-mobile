import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData.light().copyWith(
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primaryColorLight,
    ),
    colorScheme: const ColorScheme.light().copyWith(
      secondary: AppColors.primaryColorLight,
    ),
  );
}
