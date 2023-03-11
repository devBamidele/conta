import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

extension TimeOfDayExtension on TimeOfDay {
  String timeFormat() {
    return '$hour : $minute ${period.name}';
  }
}

extension TimeStampExtension on Timestamp {
  String timeFormat() => DateFormat.jm().format(toDate());
}

extension TimestampExtension on Timestamp {
  String lastSeen() {
    DateTime dateTime = toDate();
    DateTime now = DateTime.now();
    if (dateTime.year != now.year) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (dateTime.day != now.day) {
      int hour = dateTime.hour;
      String period = 'AM';
      if (hour > 12) {
        hour = hour - 12;
        period = 'PM';
      }
      return 'Yesterday at $hour:${dateTime.minute} $period';
    } else {
      int hour = dateTime.hour;
      String period = 'am';
      if (hour > 12) {
        hour = hour - 12;
        period = 'pm';
      }
      String minute = dateTime.minute.toString().padLeft(2, '0');
      return 'Today at $hour:$minute $period';
    }
  }
}

/*

import 'package:intl/intl.dart';

// Get the Timestamp object
Timestamp timestamp = Timestamp.now();

// Convert the Timestamp object to a DateTime object
DateTime dateTime = timestamp.toDate();

// Format the DateTime object to get the time in the format of "9:09 PM"
String formattedTime = DateFormat.jm().format(dateTime);

print(formattedTime); // Output: 8:56 PM

 */
