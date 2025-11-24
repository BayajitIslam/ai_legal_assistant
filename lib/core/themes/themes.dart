import 'package:flutter/material.dart';
import 'package:template/core/constants/app_colors.dart';

class MyAppThemes {
  static ThemeData get lightThemes => ThemeData(
    brightness: Brightness.light,
    elevatedButtonTheme: ElevatedButtonThemeData(),
    appBarTheme: AppBarTheme(),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(),
    floatingActionButtonTheme: FloatingActionButtonThemeData(),
    textTheme: TextTheme(),
    bottomSheetTheme: BottomSheetThemeData(),
    useMaterial3: true,
    useSystemColors: true,
    buttonTheme: ButtonThemeData(),
    cardTheme: CardThemeData(),
    checkboxTheme: CheckboxThemeData(),
    progressIndicatorTheme: ProgressIndicatorThemeData(),
    cardColor: DefaultSelectionStyle.defaultColor,
    scaffoldBackgroundColor: AppColors.bg,
  );
}
