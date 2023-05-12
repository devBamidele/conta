import 'package:flutter/material.dart';

import '../color.dart';

class AppBarIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback? onTap;
  final Matrix4? transform;

  const AppBarIcon({
    Key? key,
    required this.icon,
    required this.size,
    this.onTap,
    this.transform,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform(
        alignment: Alignment.center,
        transform: transform ?? Matrix4.identity(),
        child: Icon(
          icon,
          color: AppColors.extraTextColor,
          size: size,
        ),
      ),
    );
  }
}
