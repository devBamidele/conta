import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String senderId;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  ChatMessage({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'senderId': senderId,
        'receiverId': receiverId,
        'message': message,
        'timestamp': timestamp,
      };
}
