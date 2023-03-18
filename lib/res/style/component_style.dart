import 'package:conta/res/color.dart';
import 'package:flutter/material.dart';

/// The border for the input fields
const inputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: AppColors.inputBackGround),
  borderRadius: BorderRadius.all(
    Radius.circular(12),
  ),
);

/// The border for the input fields
const chatInputBorder = OutlineInputBorder(
  borderSide: BorderSide(
    color: AppColors.backGroundColor,
  ),
  borderRadius: BorderRadius.all(
    Radius.circular(25),
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
final loginOptionsStyle = OutlinedButton.styleFrom(
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

/// The decoration for the Resend Button
ButtonStyle resendButtonStyle({
  Color? foregroundColor,
  Color? sideColor,
  Color? backgroundColor,
  double? elevation,
  Size? minimumSize,
  BorderRadiusGeometry? borderRadius,
}) {
  return OutlinedButton.styleFrom(
    foregroundColor: foregroundColor ?? AppColors.dividerColor,
    side: BorderSide(
      color: sideColor ?? AppColors.primaryColor,
    ),
    backgroundColor: backgroundColor ?? Colors.white,
    elevation: elevation ?? 0,
    minimumSize: minimumSize ?? const Size(double.infinity, 58),
    shape: RoundedRectangleBorder(
      borderRadius: borderRadius ?? BorderRadius.circular(28),
    ),
  );
}

ButtonStyle getOutlinedButtonStyle(Color backgroundColor) {
  return OutlinedButton.styleFrom(
    backgroundColor: backgroundColor,
    side: const BorderSide(
      color: Colors.blue,
    ),
    minimumSize: const Size(double.infinity, 58),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(28),
      ),
    ),
  );
}

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
