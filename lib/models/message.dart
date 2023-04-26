import 'package:cloud_firestore/cloud_firestore.dart';

/// The class representing a [Message] object
/// Like an actual message when chatting

class Message {
  final String id;
  final String senderId;
  final String recipientId;
  final String content;
  final Timestamp timestamp;
  final bool seen;
  final bool sent;
  final bool reply;
  final String? sender;
  final String? replyMessage;

  Message({
    required this.id,
    required this.senderId,
    required this.recipientId,
    required this.content,
    required this.timestamp,
    this.seen = false,
    this.sent = false,
    this.reply = false,
    this.sender,
    this.replyMessage,
  });

  // Deserialize the JSON data received from Firestore into a Message object.
  Message.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        senderId = json['senderId'],
        recipientId = json['recipientId'],
        content = json['content'],
        timestamp = json['timestamp'],
        seen = json['seen'],
        sent = json['sent'],
        reply = json['reply'] ?? false,
        sender = json['sender'],
        replyMessage = json['message'];

  // Serialize the Message object into a JSON object for storage in Firestore.
  Map<String, dynamic> toJson() => {
        'id': id,
        'senderId': senderId,
        'recipientId': recipientId,
        'content': content,
        'timestamp': timestamp,
        'seen': seen,
        'sent': sent,
        'reply': reply,
        'sender': sender,
        'message': replyMessage,
      };
}
