import 'package:flutter/material.dart';

import '../../color.dart';

class CustomFAB extends StatelessWidget {
  const CustomFAB({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: AppColors.primaryShadeColor,
      child: const Icon(
        Icons.add,
        color: AppColors.backGroundColor,
        size: 30,
      ),
    );
  }
}
