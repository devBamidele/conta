import 'package:flutter/material.dart';

import '../color.dart';

class AppTextStyles {
  // Username on the app bar
  static const TextStyle titleMedium = TextStyle(
    fontSize: 17.5,
    height: 1.2,
    fontWeight: FontWeight.w500,
  );

  // Header text for authentication pages
  static const TextStyle headlineLarge = TextStyle(
    height: 1.1,
    fontSize: 42,
    fontWeight: FontWeight.bold,
  );

  // Sub-Header text for authentication pages
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 16,
    height: 1.25,
    color: AppColors.opaqueTextColor,
  );

  // Authentication button style
  static const TextStyle labelMedium = TextStyle(
    fontSize: 18,
    letterSpacing: 0.5,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  // Clickable text on Auth pages
  static const TextStyle labelSmall = TextStyle(
    fontSize: 16,
    height: 1.4,
    letterSpacing: 0.2,
    color: AppColors.primaryColor,
  );

  // Username on the app bar
  static const TextStyle titleSmall = TextStyle(
    fontSize: 18,
    height: 1.4,
    letterSpacing: 0.2,
    color: AppColors.continueWithColor,
  );
}

/*

  static const TextStyle labelMedium = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle labelSmall = TextStyle(
    //color: AppColors.textColor2,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.4,
    letterSpacing: 0.2,
  );

  static const TextStyle headlineMedium = TextStyle(
    color: Colors.white,
    fontSize: 19.5,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    // color: AppColors.textColor1,
  );

 static const TextStyle bodyLarge = TextStyle(
    // color: AppColors.textColor1,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyMedium = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodySmall = TextStyle(
    // color: AppColors.fadedTextColor,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
 */
