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
  final MessageStatus lastMessageStatus;
  final String lastMessageId;
  final List<bool> userMuted;
  final List<bool> userBlocked;
  final List<bool> deletedAccount;

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
    List<bool>? userBlocked,
    List<bool>? deletedAccount,
  })  : userMuted = userMuted ?? List.filled(2, false),
        userBlocked = userBlocked ?? List.filled(2, false),
        deletedAccount = deletedAccount ?? List.filled(2, false);

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
        userBlocked = List<bool>.from(json['userBlocked']),
        deletedAccount =
            List<bool>.from(json['deletedAccount'] ?? [false, false]),
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
        'userBlocked': userBlocked,
        "lastMessageId": lastMessageId,
        'deletedAccount': deletedAccount,
        'lastMessageStatus': lastMessageStatus.name.toString(),
      };
}
