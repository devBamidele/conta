import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conta/utils/enums.dart';

/// The class representing a [Message] object in the chat.
///
/// A message contains information such as sender ID, recipient ID, content,
/// timestamp, and other metadata.
class Message {
  final String id;
  final String senderId;
  final String recipientId;
  final String content;
  final Timestamp timestamp;
  final bool seen;
  final bool sent;
  final bool reply;
  final String messageType;
  final String? replyMessage;
  final String? replySenderId;
  final List<String>? media;
  bool selected = false;

  /// Constructs a [Message] object.
  ///
  /// The [id] is the unique identifier of the message.
  /// The [senderId] is the ID of the sender who sent the message.
  /// The [recipientId] is the ID of the recipient who received the message.
  /// The [content] is the text content of the message.
  /// The [timestamp] is the timestamp when the message was sent.
  /// The [messageType] indicates the type of message, such as text, image, etc.
  /// The [seen], [sent], and [reply] are optional flags for message status.
  /// The [replySender] and [replyMessage] are optional fields for additional information.
  Message({
    required this.id,
    required this.senderId,
    required this.recipientId,
    required this.content,
    required this.timestamp,
    required this.messageType,
    this.seen = false,
    this.sent = false,
    this.reply = false,
    this.media,
    this.replyMessage,
    this.replySenderId,
  });

  /// Deserialize the JSON data received from Firestore into a [Message] object.
  ///
  /// The [json] is a JSON object representing the message data.
  Message.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        senderId = json['senderId'],
        recipientId = json['recipientId'],
        content = json['content'],
        timestamp = json['timestamp'],
        seen = json['seen'],
        sent = json['sent'],
        reply = json['reply'] ?? false,
        replyMessage = json['message'],
        replySenderId = json['replySenderId'],
        messageType = json['messageType'] ?? MessageType.text.name,
        media = json['media'] != null ? List<String>.from(json['media']) : null;

  /// Serialize the [Message] object into a JSON object for storage in Firestore.
  Map<String, dynamic> toJson() => {
        'id': id,
        'senderId': senderId,
        'recipientId': recipientId,
        'content': content,
        'timestamp': timestamp,
        'seen': seen,
        'sent': sent,
        'reply': reply,
        'message': replyMessage,
        'replySenderId': replySenderId,
        'messageType': messageType,
        'media': media,
      };

  /// Update the value of the `selected` flag.
  ///
  /// The [newValue] indicates the new value for the `selected` flag.
  void updateSelected(bool newValue) {
    selected = newValue;
  }

  @override
  String toString() {
    return 'Message{\n'
        '  id: $id,\n'
        '  senderId: $senderId,\n'
        '  recipientId: $recipientId,\n'
        '  content: $content,\n'
        '  timestamp: $timestamp,\n'
        '  seen: $seen,\n'
        '  sent: $sent,\n'
        '  reply: $reply,\n'
        '  messageType: $messageType,\n'
        '  replySenderId: $replySenderId,\n'
        '  replyMessage: $replyMessage,\n'
        '  media: $media,\n'
        '  selected: $selected\n'
        '}';
  }
}
