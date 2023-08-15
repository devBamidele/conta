import 'package:conta/res/color.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

/// The border for the input fields
const inputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: AppColors.inputBackGround),
  borderRadius: BorderRadius.all(
    Radius.circular(12),
  ),
);

/// The decoration for the elevated button
final elevatedButton = ElevatedButton.styleFrom(
  backgroundColor: AppColors.primaryShadeColor,
  minimumSize: const Size(double.infinity, 54),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(24),
    ),
  ),
);

const dialogShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(10),
  ),
);

/// The border for the input fields
InputBorder customBorder({
  required bool isReplying,
  double curve = 20,
}) {
  return OutlineInputBorder(
    borderSide: const BorderSide(
      color: AppColors.backGroundColor,
    ),
    borderRadius: BorderRadius.only(
      topLeft: isReplying ? Radius.zero : Radius.circular(curve),
      topRight: isReplying ? Radius.zero : Radius.circular(curve),
      bottomLeft: Radius.circular(curve),
      bottomRight: Radius.circular(curve),
    ),
  );
}

/// The decoration for the outlined button
final loginOptionsStyle = OutlinedButton.styleFrom(
  side: BorderSide(color: AppColors.dividerColor),
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
    side: BorderSide(color: sideColor ?? AppColors.primaryShadeColor),
    backgroundColor: backgroundColor ?? Colors.white,
    elevation: elevation ?? 0,
    minimumSize: minimumSize ?? const Size(double.infinity, 54),
    shape: RoundedRectangleBorder(
      borderRadius: borderRadius ?? BorderRadius.circular(24),
    ),
  );
}

final shadow = BoxShadow(
  color: AppColors.primaryColor.withOpacity(0.7),
  offset: const Offset(1, 4),
  blurRadius: 15,
  spreadRadius: 1,
);

const pagePadding = EdgeInsets.symmetric(horizontal: 20);

const chatFieldPadding = EdgeInsets.fromLTRB(10, 5, 10, 10);

const scrollingDotsEffect = ScrollingDotsEffect(
  dotHeight: 11,
  dotWidth: 11,
  activeDotScale: 1.4,
  spacing: 10,
  activeDotColor: AppColors.replyMessageColor,
  dotColor: AppColors.extraTextColor,
);

const customGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  childAspectRatio: 1.0,
  mainAxisSpacing: 5.0,
  crossAxisSpacing: 5.0,
);

const tileContentPadding = EdgeInsets.symmetric(vertical: 2, horizontal: 20);

final tabIndicator = BoxDecoration(
  borderRadius: BorderRadius.circular(13),
  color: AppColors.primaryShadeColor,
);
