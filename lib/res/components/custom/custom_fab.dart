import 'package:flutter/material.dart';

import '../../color.dart';

class CustomFAB extends StatelessWidget {
  const CustomFAB({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: SizedBox(
        width: 65,
        height: 65,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: onPressed,
            child: const Icon(
              Icons.add,
              size: 30,
              color: AppColors.primaryShadeColor,
            ),
          ),
        ),
      ),
    );
  }
}
