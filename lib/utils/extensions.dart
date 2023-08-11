import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:intl/intl.dart';

import 'enums.dart';

extension TimeStampExtensions on Timestamp {
  String customFormat() => DateFormat.jm().format(toDate());

  bool isSameDay(Timestamp time) {
    final first = toDate();
    final second = time.toDate();
    return (first.year == second.year &&
        first.month == second.month &&
        first.day == second.day);
  }

  String toStringForSinglePic() => DateFormat('d MMMM, HH:mm').format(toDate());

  String toStringForMultiplePics() =>
      DateFormat('dd MMMM yyyy').format(toDate());
}

extension StringExtentions on String? {
  /// Validate the input value (length should be at least 6 characters)
  String? validatePassword() {
    if (this == null) {
      return 'Input is required';
    } else if (this!.length < 6) {
      return 'Enter a minimum of 6 characters';
    }
    return null; // Return null if input is valid
  }

  /// Validate the email input (checks if it's a valid email format)
  String? validateEmail() {
    if (this != null && !EmailValidator.validate(this!)) {
      return 'Enter a valid email';
    }
    return null; // Return null if the email is valid
  }

  /// Validates the name input.
  /// Returns null if the name is valid, otherwise returns an error message.
  String? validateName() {
    final value = this?.trim();
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    } else if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value)) {
      return 'Only letters, numbers, underscores, and spaces are allowed.';
    } else if (value.length < 4 || value.length > 25) {
      return 'Username must be between 4 and 20 characters long';
    } else {
      return null;
    }
  }

  /// Validates the username input.
  /// Returns null if the username is valid, otherwise returns an error message.
  /// If the username is valid, it checks if the username already exists and returns the existing username.
  String? validateUsername(String? existingUserName) {
    final value = this?.trim();
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    } else if (!RegExp(r'^[a-zA-Z0-9_\s]+$').hasMatch(value)) {
      return 'Only letters, numbers, underscores, and spaces are allowed.';
    } else if (value.length < 4 || value.length > 20) {
      return 'Username must be between 4 and 20 characters long';
    } else {
      return existingUserName;
    }
  }

  bool validateInput() {
    final value = this?.trim();
    if (value == null || value.isEmpty) {
      return false;
    } else if (!RegExp(r'^[a-zA-Z0-9_\s]+$').hasMatch(value)) {
      return false;
    } else if (value.length < 4 || value.length > 30) {
      return false;
    } else {
      return true;
    }
  }

  String shortenEmail() {
    if (this == null) {
      return '';
    }
    final start = this!.substring(0, 3);
    final end = this!.substring(this!.indexOf('@') - 2);
    const middle = '****';
    return '$start$middle$end';
  }
}

extension IntExtension on int {
  String formattedPhotos() {
    if (this == 1) {
      return '1 photo';
    } else {
      return '$this photos';
    }
  }
}

extension MessageStatusExtension on MessageStatus {
  // Converts a string to the corresponding MessageStatus enum value
  static MessageStatus fromString(String value) {
    switch (value) {
      case 'sent':
        return MessageStatus.sent;
      case 'seen':
        return MessageStatus.seen;
      case 'undelivered':
        return MessageStatus.undelivered;
      default:
        throw ArgumentError('Invalid MessageStatus value: $value');
    }
  }
}
