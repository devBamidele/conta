import 'dart:developer';

import 'package:conta/res/components/chat_list_tile.dart';
import 'package:conta/utils/app_router/router.dart';
import 'package:conta/utils/app_router/router.gr.dart';
import 'package:conta/utils/widget_functions.dart';
import 'package:conta/view_model/chat_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/chat.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({Key? key}) : super(key: key);

  static const tag = '/chat_list_view';

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  bool isNavigating = false;
  final currentUser = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (_, data, Widget? child) {
        return StreamBuilder(
          stream: data.getChatStream(),
          builder: (context, AsyncSnapshot<List<Chat>> snapshot) {
            if (snapshot.hasData) {
              final tileData = snapshot.data!;
              if (tileData.isEmpty) {
                return const Center(
                  child: Text('Empty'),
                );
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
                    onTileTap: () => onTileTap(data, tile, sameUser, oppIndex),
                    isSameUser: sameUser,
                    oppIndex: oppIndex,
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

  void navigateToNextScreen(BuildContext context) {
    if (!isNavigating) {
      isNavigating = true;
      navPush(context, const ChatScreenRoute())
          // Reset the flag when the navigation is complete
          .then((_) => isNavigating = false);
    }
  }

  void onTileTap(ChatProvider data, Chat tile, bool sameUser, int oppIndex) {
    int userIndex = oppIndex == 0 ? 1 : 0;

    //data.resetUnread(tile.chatId);
    data.setCurrentChat(
      username: sameUser ? tile.userNames[oppIndex] : tile.userNames[userIndex],
      uidUser1: sameUser ? currentUser : tile.participants[oppIndex],
      uidUser2: sameUser ? tile.participants[oppIndex] : currentUser,
      profilePicUrl: sameUser
          ? tile.profilePicUrls[oppIndex]
          : tile.profilePicUrls[userIndex],
    );

    data.cancelReplyAndClearCache();
    navigateToNextScreen(context);
  }
}
