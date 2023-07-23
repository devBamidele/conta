import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:intl/intl.dart';

extension TimeStampExtensions on Timestamp {
  String customFormat() => DateFormat.jm().format(toDate());

  String lastSeen(Timestamp currentTime) {
    final time = toDate();
    Duration difference = currentTime.toDate().difference(time);
    if (difference.inDays >= 2) {
      return '${time.day}/${time.month}/${time.year}';
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else if (difference.inHours >= 1) {
      return 'Last seen ${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes >= 1) {
      return 'Last seen ${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Last seen just now';
    }
  }

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
  /// Returns the file name from a URL
  String getFileName() {
    RegExp regExp = RegExp(r'2Fresized%2F(.+)_600x600\?alt');
    Match? match = regExp.firstMatch(this!);

    if (match != null && match.groupCount > 0) {
      return match.group(1)!;
    } else {
      return '';
    }
  }

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
}
