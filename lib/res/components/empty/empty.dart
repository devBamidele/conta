import 'package:flutter/material.dart';

import '../../../utils/widget_functions.dart';
import '../../color.dart';
import '../../style/app_text_style.dart';

class Empty extends StatelessWidget {
  const Empty({
    super.key,
    this.value,
    this.customMessage,
  });

  final String? value;
  final String? customMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          (value == null || value!.isEmpty)
              ? 'assets/images/empty.png'
              : 'assets/images/search.png',
          width: 180,
          height: 180,
        ),
        addHeight(8),
        Text(
          (value == null || value!.isEmpty)
              ? customMessage ?? 'Nope, nothing here'
              : 'No results found for \'$value\'',
          style: AppTextStyles.headlineSmall.copyWith(
            fontSize: 16,
            color: AppColors.blackColor,
          ),
        ),
      ],
    );
  }
}
