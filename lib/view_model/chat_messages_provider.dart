import 'package:flutter/material.dart';
import 'package:conta/models/chat.dart';
import 'package:conta/data/sample_messages.dart';

class ChatMessagesProvider extends ChangeNotifier {
  /// Get the messages as a json response and return a list of Json objects
  List<Chat> getMessages() {
    return Sample.sampleMessages.map((e) => Chat.fromJson(e)).toList();
  }

  /// Holds the profile information of the current selected chat
  Chat? currentChat;
}
