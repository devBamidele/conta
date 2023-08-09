import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a chat conversation between two users.
class Chat {
  final List<String> participants;
  final String? user1PicUrl;
  final String? user2PicUrl;
  final String lastMessage;
  final String lastMessageSenderId;
  final Timestamp lastMessageTimestamp;
  final num unreadCount;
  final bool user1Muted;
  final bool user2Muted;

  /// Creates a new instance of the [Chat] class.
  Chat({
    required this.participants,
    required this.user1PicUrl,
    required this.user2PicUrl,
    required this.lastMessage,
    required this.lastMessageSenderId,
    required this.lastMessageTimestamp,
    required this.unreadCount,
    this.user1Muted = false,
    this.user2Muted = false,
  });

  /// Creates a [Chat] object from a JSON representation.
  Chat.fromJson(Map<String, dynamic> json)
      : participants = List<String>.from(json['participants']),
        user1PicUrl = json['user1PicUrl'],
        user2PicUrl = json['user2PicUrl'],
        lastMessage = json['lastMessage'],
        lastMessageSenderId = json['lastMessageSenderId'],
        lastMessageTimestamp = json['lastMessageTimestamp'],
        unreadCount = json['unreadCount'],
        user1Muted = json['user1Muted'],
        user2Muted = json['user2Muted'];

  /// Converts the [Chat] object to a JSON representation.
  Map<String, dynamic> toJson() => {
        'participants': participants,
        'user1PicUrl': user1PicUrl,
        'user2PicUrl': user2PicUrl,
        'lastMessage': lastMessage,
        'lastMessageSenderId': lastMessageSenderId,
        'lastMessageTimestamp': lastMessageTimestamp,
        'unreadCount': unreadCount,
        'user1Muted': user1Muted,
        'user2Muted': user2Muted,
      };
}
