import 'package:conta/res/color.dart';
import 'package:flutter/material.dart';

/// The border for the input fields
const inputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: AppColors.inputBackGround),
  borderRadius: BorderRadius.all(
    Radius.circular(12),
  ),
);

/// The decoration for the elevated button
final elevatedButton = ElevatedButton.styleFrom(
  backgroundColor: AppColors.primaryColor,
  minimumSize: const Size(double.infinity, 58),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(28),
    ),
  ),
);

/// The decoration for the outlined button
final outlinedButton = OutlinedButton.styleFrom(
  side: BorderSide(
    color: AppColors.dividerColor,
  ),
  minimumSize: const Size(88, 60),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(16),
    ),
  ),
);

final shadow = BoxShadow(
  color: AppColors.primaryColor.withOpacity(0.7),
  offset: const Offset(1, 4),
  blurRadius: 18,
  spreadRadius: 1,
);

const photoContainerDecoration = BoxDecoration(
  color: Color(0xFFF2F2F2),
  shape: BoxShape.circle,
);

const pagePadding = EdgeInsets.symmetric(horizontal: 20);
