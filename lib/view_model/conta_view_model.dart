import 'package:flutter/material.dart';
import 'package:conta/models/message.dart';
import 'package:conta/data/sample_messages.dart';

class ContaViewModel extends ChangeNotifier {
  /// Get the messages as a json response and return a list of Json objects
  List<Message> getMessages() {
    return Sample.sampleMessages.map((e) => Message.fromJson(e)).toList();
  }
}
