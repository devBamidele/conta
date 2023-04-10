import 'package:cloud_firestore/cloud_firestore.dart';

class ChatTileData {
  final String chatId;
  final String senderId;
  final String recipientId;
  final String senderName;
  final String recipientName;
  final String? senderPicUrl;
  final String? recipientPicUrl;
  final String lastMessageSenderId;
  final String lastMessage;
  final Timestamp lastMessageTimestamp;
  final bool hasUnreadMessages;
  final num senderUnreadMessages;
  final num recipientUnreadMessages;
  final bool lastMessageSeen;
  final bool isMuted;
  final bool isArchived;

  ChatTileData({
    required this.chatId,
    required this.senderId,
    required this.recipientId,
    required this.senderName,
    required this.recipientName,
    required this.lastMessage,
    required this.lastMessageSenderId,
    required this.lastMessageTimestamp,
    this.lastMessageSeen = false,
    this.senderPicUrl,
    this.recipientPicUrl,
    required this.hasUnreadMessages,
    required this.senderUnreadMessages,
    required this.recipientUnreadMessages,
    required this.isMuted,
    required this.isArchived,
  });

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'senderId': senderId,
      'recipientId': recipientId,
      'senderName': senderName,
      'recipientName': recipientName,
      'senderPicUrl': senderPicUrl,
      'recipientPicUrl': recipientPicUrl,
      'lastMessageSenderId': lastMessageSenderId,
      'lastMessage': lastMessage,
      'lastMessageTimestamp': lastMessageTimestamp,
      'hasUnreadMessages': hasUnreadMessages,
      'senderUnreadMessages': senderUnreadMessages,
      'recipientUnreadMessages': recipientUnreadMessages,
      'lastMessageSeen': lastMessageSeen,
      'isMuted': isMuted,
      'isArchived': isArchived,
    };
  }

  factory ChatTileData.fromJson(Map<String, dynamic> json) {
    return ChatTileData(
      chatId: json['chatId'],
      senderId: json['senderId'],
      recipientId: json['recipientId'],
      senderName: json['senderName'],
      recipientName: json['recipientName'],
      senderPicUrl: json['senderPicUrl'],
      recipientPicUrl: json['recipientPicUrl'],
      lastMessageSenderId: json['lastMessageSenderId'],
      lastMessage: json['lastMessage'],
      lastMessageTimestamp: json['lastMessageTimestamp'],
      hasUnreadMessages: json['hasUnreadMessages'],
      senderUnreadMessages: json['senderUnreadMessages'],
      recipientUnreadMessages: json['recipientUnreadMessages'],
      lastMessageSeen: json['lastMessageSeen'] ?? false,
      isMuted: json['isMuted'],
      isArchived: json['isArchived'],
    );
  }
}
