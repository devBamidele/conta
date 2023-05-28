import 'package:flutter/material.dart';

import '../../color.dart';

class CustomFAB extends StatelessWidget {
  const CustomFAB({
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
      child: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: SizedBox(
          width: 35,
          height: 35,
          child: FittedBox(
            child: FloatingActionButton(
              elevation: 2,
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
      ),
    );
  }
}
