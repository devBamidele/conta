import 'dart:developer';

import 'package:conta/res/components/chat_list_tile.dart';
import 'package:conta/utils/app_router/router.dart';
import 'package:conta/utils/app_router/router.gr.dart';
import 'package:conta/utils/enums.dart';
import 'package:conta/utils/widget_functions.dart';
import 'package:conta/view_model/chat_provider.dart';
import 'package:conta/view_model/messages_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/chat.dart';
import '../../../../res/components/empty/empty.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({
    Key? key,
    this.category = MessageCategory.all,
  }) : super(key: key);

  final MessageCategory category;

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
  bool isNavigating = false;

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChatProvider, MessagesProvider>(
      builder: (_, data, info, ___) {
        return StreamBuilder<List<Chat>>(
          stream: getStream(data),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final tileData = snapshot.data!;
              if (tileData.isEmpty) {
                return Empty(value: data.chatFilter);
              }
              return ListView.builder(
                itemCount: tileData.length,
                itemBuilder: (context, index) {
                  Chat tile = tileData[index];
                  bool sameUser = tile.lastSenderUserId == currentUser;
                  int oppIndex =
                      tile.participants.indexOf(currentUser) == 0 ? 1 : 0;

                  return ChatListTile(
                    tileData: tile,
                    onTileTap: () => onTileTap(info, tile, sameUser, oppIndex),
                    isSameUser: sameUser,
                    oppIndex: oppIndex,
                    samePerson: tile.participants[0] == tile.participants[1],
                  );
                },
              );
            } else if (snapshot.hasError) {
              log('Error fetching chat tiles: ${snapshot.error}');
              return const Text('Sorry, try again later');
            } else {
              return shimmerTiles();
            }
          },
        );
      },
    );
  }

  Stream<List<Chat>> getStream(ChatProvider data) {
    switch (widget.category) {
      case MessageCategory.unread:
        return data.getUnreadChatsStream();
      case MessageCategory.muted:
        return data.getMutedChatsStream();
      case MessageCategory.all:
      default:
        return data.getAllChatsStream();
    }
  }

  void navigateToNextScreen(BuildContext context) {
    if (!isNavigating) {
      isNavigating = true;
      navPush(context, const ChatScreenRoute())
          // Reset the flag when the navigation is complete
          .then((_) => isNavigating = false);
    }
  }

  void onTileTap(
    MessagesProvider data,
    Chat tile,
    bool sameUser,
    int oppIndex,
  ) {
    data.setCurrentChat(
      username: tile.userNames[oppIndex],
      uidUser1: currentUser,
      uidUser2: tile.participants[oppIndex],
      profilePicUrl: tile.participants[0] == tile.participants[1]
          ? tile.profilePicUrls[0]
          : tile.profilePicUrls[oppIndex],
      notifications: !tile.userMuted[oppIndex],
      oppIndex: oppIndex,
      isDeleted: tile.deletedAccount[oppIndex],
    );

    data.cancelReplyAndClearCache();
    navigateToNextScreen(context);
  }
}
