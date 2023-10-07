import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../color.dart';

class CustomFAB extends StatelessWidget {
  const CustomFAB({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 52,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: AppColors.primaryShadeColor,
        child: const Icon(
          IconlyLight.edit,
          color: AppColors.backGroundColor,
          size: 26,
        ),
      ),
    );
  }
}
