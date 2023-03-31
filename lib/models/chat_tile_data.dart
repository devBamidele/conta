import 'package:cloud_firestore/cloud_firestore.dart';

class ChatTileData {
  final String chatId;
  final String userId;
  final String userName;
  final String lastMessage;
  final String profilePictureUrl;
  final Timestamp lastMessageTimestamp;
  bool hasUnreadMessages;
  int numUnreadMessages;
  bool isMuted;

  ChatTileData({
    required this.chatId,
    required this.userId,
    required this.userName,
    required this.lastMessage,
    required this.profilePictureUrl,
    required this.lastMessageTimestamp,
    this.hasUnreadMessages = false,
    this.numUnreadMessages = 0,
    this.isMuted = false,
  });

  Map<String, dynamic> toJson() => {
        'chatId': chatId,
        'userId': userId,
        'userName': userName,
        'lastMessage': lastMessage,
        'profilePictureUrl': profilePictureUrl,
        'lastMessageTimestamp': lastMessageTimestamp,
        'hasUnreadMessages': hasUnreadMessages,
        'numUnreadMessages': numUnreadMessages,
        'isMuted': isMuted,
      };

  ChatTileData.fromJson(Map<String, dynamic> json)
      : chatId = json['chatId'],
        userId = json['userId'],
        userName = json['userName'],
        lastMessage = json['lastMessage'],
        profilePictureUrl = json['profilePictureUrl'],
        lastMessageTimestamp = json['lastMessageTimestamp'],
        hasUnreadMessages = json['hasUnreadMessages'] ?? false,
        numUnreadMessages = json['numUnreadMessages'] ?? 0,
        isMuted = json['isMuted'] ?? false;
}
