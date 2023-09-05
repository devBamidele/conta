import 'package:flutter/material.dart';

import '../color.dart';

class AppBarIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback? onTap;

  const AppBarIcon({
    Key? key,
    required this.icon,
    required this.size,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        color: AppColors.extraTextColor,
        size: size,
      ),
    );
  }
}
