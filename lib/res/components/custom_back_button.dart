import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    Key? key,
    this.padding,
    this.size = 28,
    this.color = Colors.black,
  }) : super(key: key);

  final EdgeInsetsGeometry? padding;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: padding,
      alignment: Alignment.centerLeft,
      iconSize: 26,
      onPressed: () => context.router.pop(),
      icon: Icon(IconlyLight.arrow_left, color: color),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
    );
  }
}
