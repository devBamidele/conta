import 'package:cloud_firestore/cloud_firestore.dart';
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

extension StringExtentions on String {
  /// Returns the file name from a URL
  String getFileName() {
    RegExp regExp = RegExp(r'2Fresized%2F(.+)_600x600\?alt');
    Match? match = regExp.firstMatch(this);

    if (match != null && match.groupCount > 0) {
      return match.group(1)!;
    } else {
      return '';
    }
  }
}
