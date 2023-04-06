import 'package:cloud_firestore/cloud_firestore.dart';

class ChatTileData {
  final String chatId;
  final String userId;
  final String userName;
  final String lastMessage;
  final String? profilePicUrl;
  final Timestamp lastMessageTimestamp;
  bool hasUnreadMessages;
  num unreadMessagesCount;
  bool isMuted;

  ChatTileData({
    required this.chatId,
    required this.userId,
    required this.userName,
    required this.lastMessage,
    this.profilePicUrl,
    required this.lastMessageTimestamp,
    this.hasUnreadMessages = false,
    this.unreadMessagesCount = 0,
    this.isMuted = false,
  });

  Map<String, dynamic> toJson() => {
        'chatId': chatId,
        'userId': userId,
        'userName': userName,
        'lastMessage': lastMessage,
        'profilePictureUrl': profilePicUrl,
        'lastMessageTimestamp': lastMessageTimestamp,
        'hasUnreadMessages': hasUnreadMessages,
        'numUnreadMessages': unreadMessagesCount,
        'isMuted': isMuted,
      };

  ChatTileData.fromJson(Map<String, dynamic> json)
      : chatId = json['chatId'],
        userId = json['userId'],
        userName = json['userName'],
        lastMessage = json['lastMessage'],
        profilePicUrl = json['profilePicUrl'],
        lastMessageTimestamp = json['lastMessageTimestamp'],
        hasUnreadMessages = json['hasUnreadMessages'] ?? false,
        unreadMessagesCount = json['unreadMessagesCount'] ?? 0,
        isMuted = json['isMuted'] ?? false;
}
