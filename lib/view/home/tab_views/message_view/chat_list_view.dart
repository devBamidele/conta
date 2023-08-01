import 'dart:developer';

import 'package:conta/res/components/chat_list_tile.dart';
import 'package:conta/utils/app_router/router.dart';
import 'package:conta/utils/app_router/router.gr.dart';
import 'package:conta/view_model/chat_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/chat_tile_data.dart';
import '../../../../res/components/shimmer/shimmer_tile.dart';

class ChatListView extends StatefulWidget {
  const ChatListView({Key? key}) : super(key: key);

  static const tag = '/chat_list_view';

  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> {
  bool isNavigating = false;
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (_, data, Widget? child) {
        return StreamBuilder(
          stream: data.getChatTilesStream(),
          builder: (
            context,
            AsyncSnapshot<List<ChatTileData>> snapshot,
          ) {
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
                  ChatTileData tile = tileData[index];
                  bool sameUser = tile.senderId == currentUser!.uid;
                  return ChatListTile(
                    tileData: tile,
                    onTileTap: () => onTileTap(data, tile, sameUser),
                    isSameUser: sameUser,
                  );
                },
              );
            } else if (snapshot.hasError) {
              log('Error fetching chat tiles: ${snapshot.error}');
              return const Text('Sorry, try again later');
            } else {
              return ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return const ShimmerTile();
                },
              );
            }
          },
        );
      },
    );
  }

  void navigateToNextScreen(BuildContext context) {
    if (!isNavigating) {
      isNavigating = true;
      navPush(context, const ChatScreenRoute()).then((_) {
        // Reset the flag when the navigation is complete
        isNavigating = false;
      });
    }
  }

  void onTileTap(ChatProvider data, ChatTileData tile, bool sameUser) {
    data.resetUnread(tile.chatId);
    data.setCurrentChat(
      username: sameUser ? tile.recipientName : tile.senderName,
      uidUser1: sameUser ? tile.senderId : tile.recipientId,
      uidUser2: sameUser ? tile.recipientId : tile.senderId,
      profilePicUrl: sameUser ? tile.recipientPicUrl : tile.senderPicUrl,
    );

    data.cancelReplyAndClearCache();
    navigateToNextScreen(context);
  }
}
