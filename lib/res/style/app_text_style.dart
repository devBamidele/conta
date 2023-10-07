import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../color.dart';

class AppTextStyles {
  // Username on the app bar
  static const titleMedium = TextStyle(
    fontSize: 17.5,
    height: 1.2,
    fontWeight: FontWeight.w500,
    color: Colors.black,
    letterSpacing: 0.6,
  );

  static const contactsAppBarText = TextStyle(
    fontSize: 18,
    height: 1.2,
    color: AppColors.blackColor,
  );

  // Header text for authentication pages
  static const headlineLarge = TextStyle(
    height: 1.1,
    fontSize: 42,
    fontWeight: FontWeight.bold,
    color: AppColors.blackColor,
  );

  // Sub-Header text for authentication pages
  static TextStyle headlineSmall = GoogleFonts.urbanist(
    textStyle: const TextStyle(
      fontSize: 18,
      height: 1.25,
      color: AppColors.opaqueTextColor,
    ),
  );

  // Authentication button style
  static const labelMedium = TextStyle(
    fontSize: 17,
    letterSpacing: 0.8,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  // Clickable text on Auth pages
  static TextStyle labelSmall = GoogleFonts.urbanist(
    textStyle: const TextStyle(
      fontSize: 16,
      height: 1.4,
      letterSpacing: 0.3,
      color: AppColors.primaryColor,
    ),
  );

  // Username on the app bar
  static const titleSmall = TextStyle(
    fontSize: 18,
    height: 1.4,
    letterSpacing: 0.2,
    color: AppColors.continueWithColor,
  );

  // Text for the 'Recent Search' for the search screen
  static const headlineMedium = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  static const formText = TextStyle(
    fontSize: 16,
    height: 1.4,
    letterSpacing: 0.2,
  );

  static TextStyle tabLabelText = GoogleFonts.urbanist(
    textStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
      fontSize: 14,
    ),
  );

  static const listTileTitleText = TextStyle(
    fontSize: 16,
    letterSpacing: 0.6,
    fontWeight: FontWeight.bold,
    color: AppColors.blackColor,
  );

  static const contactText = TextStyle(
    fontSize: 16,
    height: 1.25,
    color: AppColors.blackColor,
    fontWeight: FontWeight.w500,
  );

  static const deleteChatText = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: AppColors.primaryShadeColor,
  );

  static const passwordText = TextStyle(
    fontSize: 16,
    color: AppColors.blackColor,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.3,
  );

  static TextStyle titleText = GoogleFonts.josefinSans(
    textStyle: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 26,
      color: AppColors.blackColor,
    ),
  );

  static TextStyle alertTitleText = GoogleFonts.urbanist(
    textStyle: const TextStyle(
      fontSize: 20,
      color: Colors.black,
      letterSpacing: 0.2,
    ),
  );

  static const profileTitleText = TextStyle(
    fontSize: 22,
    color: Colors.black,
    letterSpacing: 0.8,
  );

  static TextStyle profileSubTitleText = const TextStyle(
    fontSize: 16,
    color: AppColors.blackColor,
  );

  static TextStyle profileTileSubtitle = GoogleFonts.urbanist(
    textStyle: const TextStyle(
      fontSize: 16,
      color: AppColors.blackColor,
      fontWeight: FontWeight.w500,
    ),
  );

  static const linkStyle = TextStyle(
    color: AppColors.replyMessageColor,
    decorationThickness: 2.5,
    decorationColor: AppColors.replyMessageColor,
  );

  static const sheetTitleText = TextStyle(
    fontSize: 24,
    color: AppColors.primaryShadeColor,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.8,
  );

  static TextStyle dateTimeText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: AppColors.blackShade,
    letterSpacing: 0.8,
  );
}
