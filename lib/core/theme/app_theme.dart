import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.indigo,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.indigo),
      titleTextStyle: TextStyle(
        color: AppColors.indigo,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.darkText, fontSize: 14),
      bodySmall: TextStyle(color: AppColors.lightText, fontSize: 12),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        side: BorderSide(color: AppColors.cardBorder),
      ),
      elevation: 2,
      shadowColor: Colors.black12,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.background,
      selectedItemColor: AppColors.indigo,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 10,
      ),
      type: BottomNavigationBarType.fixed,
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.indigo,
      error: AppColors.error,
      secondary: AppColors.accentPink,
    ),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    navigationBarTheme: const NavigationBarThemeData(
      overlayColor: WidgetStatePropertyAll(Colors.transparent),
    ),
  );
}
