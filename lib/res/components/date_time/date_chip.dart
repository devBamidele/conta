import 'package:blur/blur.dart';
import 'package:flutter/material.dart';

import '../../color.dart';
import '../../style/app_text_style.dart';
import 'algo.dart';

///[DateChip] use to show the date breakers on the chat view
///[date] parameter is required
///[color] parameter is optional default color code `8AD3D5`
///
///
class DateChip extends StatelessWidget {
  final DateTime date;

  const DateChip({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 7,
        bottom: 7,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Text(
          Algo.dateChipText(date),
          style: AppTextStyles.dateTimeText,
        ),
      ).frosted(
        blur: 0,
        frostColor: AppColors.inactiveColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
    );
  }
}
