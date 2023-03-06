import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

extension TimeOfDayExtension on TimeOfDay {
  String timeFormat() {
    return '$hour : $minute ${period.name}';
  }
}

extension TimeStampExtension on Timestamp {
  String timeFormat() {
    final date = toDate();
    return DateFormat.jm().format(date);
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
