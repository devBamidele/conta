import 'package:flutter/material.dart';

import '../../../utils/widget_functions.dart';
import '../../color.dart';
import '../../style/app_text_style.dart';

class EmptyChat extends StatelessWidget {
  const EmptyChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/chat.png',
          width: 220,
          height: 220,
        ),
        addHeight(4),
        Text(
          'No messages here yet',
          style: AppTextStyles.headlineSmall.copyWith(
            fontSize: 16,
            color: AppColors.blackColor,
          ),
        ),
      ],
    );
  }
}
