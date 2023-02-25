import 'package:conta/res/color.dart';
import 'package:conta/res/style/component_style.dart';
import 'package:flutter/material.dart';

class AppTheme {
  ThemeData appTheme() {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.backGroundColor,
      useMaterial3: true,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        //fillColor: AppColors.inputBackGround,
        hintStyle: const TextStyle(
          color: AppColors.hintTextColor,
          fontWeight: FontWeight.w400,
          fontSize: 14,
          height: 1.4,
          letterSpacing: 0.2,
        ),
        errorStyle: TextStyle(
          color: AppColors.unreadColor.withOpacity(0.7),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: BorderSide(
            color: AppColors.unreadColor.withOpacity(0.7),
            width: 1.5,
          ),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: BorderSide(
            color: AppColors.unreadColor.withOpacity(0.7),
            width: 2,
          ),
        ),
        enabledBorder: inputBorder.copyWith(
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 1.5,
          ),
        ),
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(
            color: AppColors.selectedFieldColor,
            width: 1,
          ),
        ),
      ),
    );
  }
}
