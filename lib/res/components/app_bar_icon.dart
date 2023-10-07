import 'package:flutter/material.dart';

import '../color.dart';

class AppBarIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback? onTap;
  final Color? color;

  const AppBarIcon({
    Key? key,
    required this.icon,
    required this.size,
    this.onTap,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        color: color ?? AppColors.black70,
        size: size,
      ),
    );
  }
}
