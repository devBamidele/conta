import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../color.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    Key? key,
    this.padding,
    this.size = 26,
    this.icon = IconlyLight.arrow_left,
    this.align = Alignment.centerLeft,
    this.action,
  }) : super(key: key);

  final EdgeInsetsGeometry? padding;
  final double size;
  final IconData icon;
  final AlignmentGeometry align;
  final Function()? action;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: padding,
      alignment: align,
      iconSize: size,
      onPressed: () => action != null ? action!() : context.router.pop(),
      icon: Icon(icon, color: AppColors.blackColor),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
    );
  }
}
