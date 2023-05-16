import 'package:flutter/material.dart';

import '../color.dart';

class SnackBarLabel extends StatelessWidget {
  final VoidCallback onTap;

  const SnackBarLabel({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Text(
        'UNDO',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
