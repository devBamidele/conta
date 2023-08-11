import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/enums.dart';
import '../utils/extensions.dart';

class Chat {
  final String? id;
  final List<String> participants;
  final List<String> userNames;
  final List<String?> profilePicUrls;
  final String lastMessage;
  final String lastSenderUserId;
  final Timestamp lastMessageTimestamp;
  final num unreadCount;
  final List<bool> userMuted;
  final MessageStatus lastMessageStatus;
  final String lastMessageId;

  Chat({
    this.id,
    required this.participants,
    required this.userNames,
    required this.profilePicUrls,
    required this.lastMessage,
    required this.lastSenderUserId,
    required this.lastMessageTimestamp,
    required this.unreadCount,
    this.lastMessageStatus = MessageStatus.undelivered,
    required this.lastMessageId,
    List<bool>? userMuted,
  }) : userMuted = userMuted ?? List.filled(2, false);

  Chat.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        participants = List<String>.from(json['participants']),
        profilePicUrls = List<String?>.from(json['profilePicUrls']),
        userNames = List<String>.from(json['names']),
        lastMessage = json['lastMessage'],
        lastSenderUserId = json['lastSenderUserId'],
        lastMessageTimestamp = json['lastMessageTimestamp'],
        unreadCount = json['unreadCount'],
        userMuted = List<bool>.from(json['userMuted']),
        lastMessageId = json['lastMessageId'] ?? '',
        lastMessageStatus =
            MessageStatusExtension.fromString(json['lastMessageStatus']);

  Map<String, dynamic> toJson() => {
        'participants': participants,
        'profilePicUrls': profilePicUrls,
        'names': userNames,
        'lastMessage': lastMessage,
        'lastSenderUserId': lastSenderUserId,
        'lastMessageTimestamp': lastMessageTimestamp,
        'unreadCount': unreadCount,
        'userMuted': userMuted,
        "lastMessageId": lastMessageId,
        'lastMessageStatus': lastMessageStatus.name.toString(),
      };
}
