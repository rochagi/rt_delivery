import 'package:flutter/material.dart';
import 'package:rt_flash/config/theme/app_colors.dart';

final appTheme = ThemeData(
    drawerTheme: DrawerThemeData(
      backgroundColor: AppColors.lightBlue,
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(
        color: AppColors.darkBLue,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      bodyLarge: TextStyle(
        color: AppColors.darkBLue,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: AppColors.darkBLue,
        fontWeight: FontWeight.w600,
        fontSize: 22,
      ),
      titleLarge: TextStyle(
        color: AppColors.darkBLue,
        fontWeight: FontWeight.w700,
        fontSize: 25,
      ),
      headlineLarge: TextStyle(
        color: AppColors.white,
        fontWeight: FontWeight.w700,
        fontSize: 35,
      ),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.darkBLue,
      iconTheme: IconThemeData(
        color: AppColors.white,
      ),
      titleTextStyle: TextStyle(
          color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 22),
    ),
    scaffoldBackgroundColor: AppColors.lightGrey,
    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.white,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.greyMedium;
            }
            return AppColors.orange;
          },
        ),
      ),
    ));
