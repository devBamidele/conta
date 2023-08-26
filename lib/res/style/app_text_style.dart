import 'package:flutter/material.dart';

import '../color.dart';

class AppTextStyles {
  // Username on the app bar
  static const TextStyle titleMedium = TextStyle(
    fontSize: 17.5,
    height: 1.2,
    fontWeight: FontWeight.w500,
    color: AppColors.blackColor,
  );

  // Header text for authentication pages
  static const TextStyle headlineLarge = TextStyle(
    height: 1.1,
    fontSize: 42,
    fontWeight: FontWeight.bold,
    color: AppColors.blackColor,
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
    letterSpacing: 0.3,
    color: AppColors.primaryColor,
  );

  // Username on the app bar
  static const TextStyle titleSmall = TextStyle(
    fontSize: 18,
    height: 1.4,
    letterSpacing: 0.2,
    color: AppColors.continueWithColor,
  );

  // Text for the 'Recent Search' for the search screen
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  static const TextStyle formText = TextStyle(
    fontSize: 16,
    height: 1.4,
    letterSpacing: 0.2,
  );

  static const TextStyle textFieldLabel = TextStyle(
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
    fontSize: 14,
  );

  static const TextStyle contactText = TextStyle(
    fontSize: 16,
    height: 1.25,
    color: AppColors.blackColor,
    fontWeight: FontWeight.w500,
  );
}
