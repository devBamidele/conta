import 'package:flutter/material.dart';

import '../../../utils/widget_functions.dart';
import '../../color.dart';
import '../../style/app_text_style.dart';

class Empty extends StatelessWidget {
  const Empty({
    super.key,
    this.value,
  });

  final String? value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/empty.png',
          width: 170,
          height: 170,
        ),
        addHeight(8),
        Text(
          (value == null || value!.isEmpty)
              ? 'Nope, nothing here'
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
