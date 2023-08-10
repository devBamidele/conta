import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/enums.dart';

class Chat {
  final List<String> participants;
  final List<String> userNames;
  final List<String?> profilePicUrls;
  final String lastMessage;
  final String lastSenderUserId;
  final Timestamp lastMessageTimestamp;
  final num unreadCount;
  final List<bool> userMuted;
  final MessageStatus lastMessageStatus;

  Chat({
    required this.participants,
    required this.userNames,
    required this.profilePicUrls,
    required this.lastMessage,
    required this.lastSenderUserId,
    required this.lastMessageTimestamp,
    required this.unreadCount,
    required this.lastMessageStatus,
    List<bool>? userMuted,
  }) : userMuted = userMuted ?? List.filled(2, false);

  Chat.fromJson(Map<String, dynamic> json)
      : participants = List<String>.from(json['participants']),
        profilePicUrls = List<String?>.from(json['profilePicUrls']),
        userNames = List<String>.from(json['names']),
        lastMessage = json['lastMessage'],
        lastSenderUserId = json['lastSenderUserId'],
        lastMessageTimestamp = json['lastMessageTimestamp'],
        unreadCount = json['unreadCount'],
        userMuted = List<bool>.from(json['userMuted']),
        lastMessageStatus = MessageStatus.sent;

  Map<String, dynamic> toJson() => {
        'participants': participants,
        'profilePicUrls': profilePicUrls,
        'names': userNames,
        'lastMessage': lastMessage,
        'lastSenderUserId': lastSenderUserId,
        'lastMessageTimestamp': lastMessageTimestamp,
        'unreadCount': unreadCount,
        'userMuted': userMuted,
        'lastMessageStatus': lastMessageStatus.toString(),
      };
}
