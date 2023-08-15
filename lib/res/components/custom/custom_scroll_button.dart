import 'package:flutter/material.dart';

import '../../color.dart';

class CustomScrollButton extends StatelessWidget {
  const CustomScrollButton({
    Key? key,
    required this.showIcon,
    this.onPressed,
  }) : super(key: key);

  final bool showIcon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: showIcon,
      child: SizedBox.square(
        dimension: 32,
        child: FittedBox(
          child: FloatingActionButton(
            elevation: 4,
            backgroundColor: Colors.white,
            onPressed: onPressed,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.keyboard_arrow_down_outlined,
              size: 45,
              color: AppColors.extraTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
