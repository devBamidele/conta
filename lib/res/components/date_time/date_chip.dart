import 'package:flutter/material.dart';

import '../../color.dart';
import 'algo.dart';

///[DateChip] use to show the date breakers on the chat view
///[date] parameter is required
///[color] parameter is optional default color code `8AD3D5`
///
///
class DateChip extends StatelessWidget {
  final DateTime date;
  final Color color;

  const DateChip({
    Key? key,
    required this.date,
    this.color = AppColors.dateChipColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 7,
        bottom: 7,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            Algo.dateChipText(date),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.blackColor,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }
}
