import 'message.dart';

/// Represents a Chat between two users, containing a unique [id], the [user1Id] and [user2Id]
/// of the users involved, a list of [messages] exchanged in the chat, the [lastSeenUserId] of
/// the last user to see the chat, and a [muted] boolean to indicate if notifications are muted.
class Chat {
  final String id;
  final String user1Id;
  final String user2Id;
  final List<Message> messages;
  final String? lastSeenUserId;
  final bool muted;

  Chat({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.messages,
    this.lastSeenUserId,
    this.muted = false,
  });

  /// Create a Chat object from a JSON representation.
  Chat.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        user1Id = json['user1Id'],
        user2Id = json['user2Id'],
        messages = (json['messages'] as List)
            .map((messageJson) => Message.fromJson(messageJson))
            .toList(),
        lastSeenUserId = json['lastSeenUserId'],
        muted = json['muted'];

  /// Convert the Chat object to a JSON representation.
  Map<String, dynamic> toJson() => {
        'id': id,
        'user1Id': user1Id,
        'user2Id': user2Id,
        'messages': messages.map((message) => message.toJson()).toList(),
        'lastSeenUserId': lastSeenUserId,
        'muted': muted,
      };

  /// Returns the id of the user in the chat that is not [userId].
  String getOtherUserId(String userId) {
    return userId == user1Id ? user2Id : user1Id;
  }

  /// Returns a boolean indicating if the chat has any unread messages for [userId].
  bool isUnread(String userId) {
    if (messages.isEmpty) {
      return false;
    }
    final lastMessage = messages.last;
    return lastMessage.senderId != userId && lastMessage.seen;
  }
}
