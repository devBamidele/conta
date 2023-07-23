import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    Key? key,
    this.padding,
    this.size = 26,
    this.color = Colors.black,
    this.onPressed,
  }) : super(key: key);

  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: padding,
      alignment: Alignment.centerLeft,
      iconSize: size,
      onPressed: () {
        context.router.pop().then(
              (value) => {
                if (onPressed != null) {onPressed!()}
              },
            );
      },
      icon: Icon(IconlyLight.arrow_left, color: color),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
    );
  }
}
