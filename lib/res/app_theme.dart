import 'package:conta/res/color.dart';
import 'package:conta/res/style/component_style.dart';
import 'package:flutter/material.dart';

class AppTheme {
  ThemeData appTheme() {
    return ThemeData(
      // Set the background color of the scaffold (app screen).
      scaffoldBackgroundColor: AppColors.backGroundColor,

      // Enable the use of Material3, the latest Material Design system.
      useMaterial3: true,

      // Configure the dialog theme.
      dialogTheme: const DialogTheme(
        // Set the style for the title of the dialog.
        titleTextStyle: TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
        // Set the shape of the dialog.
        shape: dialogShape,
      ),

      textTheme: TextTheme(),

      // Configure the app bar theme.
      appBarTheme: const AppBarTheme(
        // Set the shadow color of the app bar.
        shadowColor: AppColors.inactiveColor,
        // Set the color of the app bar's surface (background).
        surfaceTintColor: Colors.white,
        // Set the elevation applied when the app bar is scrolled under.
        scrolledUnderElevation: 2,
        // Set the spacing between the app bar's title and other components.
        titleSpacing: 5,
      ),

      dividerColor: Colors.grey[200],
      // Configure the input decoration theme for form fields.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        // Set the style for the hint text displayed when the field is empty.
        hintStyle: const TextStyle(
          color: AppColors.hintTextColor,
          fontWeight: FontWeight.w400,
          fontSize: 16,
          height: 1.4,
          letterSpacing: 0.2,
        ),
        // Set the style for the error text displayed when there is an input error.
        errorStyle: TextStyle(
          color: AppColors.errorBorderColor.withOpacity(0.7),
        ),
        // Set the border style for the field when there is an input error.
        errorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(
            color: AppColors.errorBorderColor,
            width: 1,
          ),
        ),
        // Set the border style for the field when focused and there is an input error.
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: BorderSide(
            color: AppColors.errorBorderColor.withOpacity(0.7),
            width: 1.5,
          ),
        ),
        // Set the border style for the field when enabled and not focused.
        enabledBorder: inputBorder.copyWith(
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        // Set the border style for the field when focused.
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
