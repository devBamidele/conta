/// The class representing a [Message] object
/// Like an actual message when chatting
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String senderId;
  final String recipientId;
  final String content;
  final Timestamp timestamp;
  final bool isUnread;

  Message({
    required this.id,
    required this.senderId,
    required this.recipientId,
    required this.content,
    required this.timestamp,
    required this.isUnread,
  });

  // Deserialize the JSON data received from Firestore into a Message object.
  Message.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        senderId = json['senderId'],
        recipientId = json['recipientId'],
        content = json['content'],
        timestamp = json['timestamp'],
        isUnread = json['isUnread'];

  // Serialize the Message object into a JSON object for storage in Firestore.
  Map<String, dynamic> toJson() => {
        'id': id,
        'senderId': senderId,
        'recipientId': recipientId,
        'content': content,
        'timestamp': timestamp,
        'isUnread': isUnread,
      };
}
