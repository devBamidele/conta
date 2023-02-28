import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    Key? key,
    required this.padding,
    this.size = 28,
  }) : super(key: key);

  final EdgeInsetsGeometry padding;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: padding,
      alignment: Alignment.centerLeft,
      iconSize: 26,
      onPressed: () => context.router.pop(),
      icon: const Icon(
        IconlyLight.arrow_left,
      ),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
    );
  }
}
