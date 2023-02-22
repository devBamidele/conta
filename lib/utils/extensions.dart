import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  String timeFormat() {
    return '$hour : $minute ${period.name}';
  }
}
