import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conta/res/color.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../models/message.dart';
import '../res/components/shimmer/shimmer_tile.dart';
import 'enums.dart';

Widget addHeight(double height) => SizedBox(height: height);

Widget addWidth(double width) => SizedBox(width: width);

Widget displayLoading() {
  return Center(
    child: LoadingAnimationWidget.prograssiveDots(
      color: Colors.white,
      size: 50,
    ),
  );
}

Icon visibilityIcon(bool isVisible, Color passwordColor) {
  return Icon(
    // Based on passwordVisible state choose the icon
    isVisible ? Icons.visibility_off : Icons.visibility,
    color: passwordColor,
    size: 20,
  );
}

Widget emailIcon(Color color) {
  return Icon(
    IconlyLight.message,
    color: color,
    size: 22,
  );
}

Icon lockIcon(Color iconColor) {
  return Icon(
    IconlyLight.lock,
    color: iconColor,
    size: 22,
  );
}

Icon phoneIcon(Color iconColor) {
  return Icon(
    IconlyLight.call,
    color: iconColor,
    size: 22,
  );
}

Widget doubleTick({double size = 20}) {
  return Icon(
    Icons.done_all_rounded,
    color: Colors.greenAccent,
    size: size,
  );
}

Widget singleTick({double size = 19}) {
  return Icon(
    Icons.check,
    color: Colors.greenAccent,
    size: size,
  );
}

Widget noProfilePic({double size = 25}) {
  return Icon(
    IconlyBold.profile,
    color: AppColors.hintTextColor,
    size: size,
  );
}

Icon errorIcon({double size = 27}) {
  return Icon(
    Icons.error,
    size: size,
  );
}

/// The following icons track the state of the message
Icon sentIcon(Color color) {
  return Icon(
    Icons.done,
    size: 13,
    color: color,
  );
}

Icon offlineIcon(Color color, {double size = 13}) {
  return Icon(
    Icons.wifi_off_rounded,
    size: size,
    color: color,
  );
}

Widget messageStatus(MessageStatus status) {
  if (status == MessageStatus.sent) {
    return singleTick();
  } else if (status == MessageStatus.seen) {
    return doubleTick();
  } else {
    return offlineIcon(AppColors.iconColor);
  }
}

Icon seenIcon(Color color) {
  return Icon(
    Icons.done_all,
    size: 13,
    color: color,
  );
}

Widget replyIcon() {
  return const Icon(
    Icons.reply_rounded,
    size: 30,
    color: AppColors.primaryColor,
  );
}

Widget sendIcon() {
  return const Icon(
    IconlyBold.send,
    size: 23,
    color: Colors.white,
  );
}

Widget voiceIcon() {
  return const Icon(
    IconlyBold.voice,
    size: 23,
    color: Colors.white,
  );
}

Widget returnArrow() {
  return const Icon(
    IconlyLight.arrow_left,
    size: 24,
    color: AppColors.opaqueTextColor,
  );
}

Widget clearIcon() {
  return const Icon(
    Icons.clear_rounded,
    size: 24,
    color: AppColors.opaqueTextColor,
  );
}

Widget searchIcon({Color? color}) {
  return Icon(
    IconlyLight.search,
    color: color ?? AppColors.hintTextColor,
    size: 20,
  );
}

Widget shimmerTiles() {
  return ListView.builder(
    itemCount: 10,
    itemBuilder: (context, index) {
      return const ShimmerTile();
    },
  );
}

Message createSingleMessage(
  String messageId,
  String currentUser,
  String secondUser,
  String content,
  MessageType type,
  List<String>? media,
  bool reply,
  String? replyMessage,
  String? replyId,
) {
  return Message(
    id: messageId,
    senderId: currentUser,
    recipientId: secondUser,
    content: content,
    timestamp: Timestamp.now(),
    reply: reply,
    replyMessage: replyMessage,
    replySenderId: replyId,
    messageType: type.name,
    media: media,
  );
}

Message createMediaMessage(
  String id,
  String currentUser,
  String secondUser,
  String content,
  String mediaUrl,
) {
  return Message(
    id: id,
    senderId: currentUser,
    recipientId: secondUser,
    content: content,
    timestamp: Timestamp.now(),
    messageType: MessageType.media.name,
    media: [mediaUrl],
  );
}

EdgeInsets getBubblePadding(
  bool isSender,
  bool stateTick,
  bool hasMedia,
  bool hasReplyMessage,
  bool hasContent,
) {
  if (isSender) {
    if (stateTick) {
      if (hasReplyMessage) {
        return const EdgeInsets.fromLTRB(3.5, 3, 13, 7);
      } else if (hasMedia) {
        return EdgeInsets.fromLTRB(1, 4, 14, hasContent ? 8 : 2);
      } else {
        return const EdgeInsets.fromLTRB(7, 7, 14, 7);
      }
    } else {
      return const EdgeInsets.fromLTRB(7, 7, 17, 7);
    }
  } else {
    if (hasReplyMessage) {
      return const EdgeInsets.fromLTRB(14, 3, 3, 7);
    } else if (hasMedia) {
      return EdgeInsets.fromLTRB(9, 3, 3, hasContent ? 8 : 0.5);
    } else {
      return const EdgeInsets.fromLTRB(16, 7, 3, 7);
    }
  }
}

EdgeInsets getContentPadding(
  bool replyMessage,
  bool hasMedia,
) {
  return EdgeInsets.only(
    left: replyMessage || hasMedia ? 8 : 0,
    top: replyMessage || hasMedia ? 3 : 0,
  );
}
