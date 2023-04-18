import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:conta/res/components/chat_list_tile.dart';
import 'package:conta/view_model/chat_messages_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/chat_tile_data.dart';
import '../../../../res/components/shimmer_tile.dart';
import 'chat_screen.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({Key? key}) : super(key: key);

  static const tag = '/chat_list_view';

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatMessagesProvider>(
      builder: (_, data, Widget? child) {
        return StreamBuilder(
          stream: data.getChatTilesStream(),
          builder: (
            context,
            AsyncSnapshot<List<ChatTileData>> snapshot,
          ) {
            if (snapshot.hasData) {
              List<ChatTileData> tileData = snapshot.data!;
              if (tileData.isEmpty) {
                return const Center(
                  child: Text('Empty'),
                );
              }
              return ListView.builder(
                itemCount: tileData.length,
                itemBuilder: (context, index) {
                  ChatTileData tile = tileData[index];
                  bool sameUser = tile.senderId == data.currentUser!.uid;
                  return ChatListTile(
                    tileData: tile,
                    onTileTap: () {
                      data.resetUnread(tile.chatId);
                      data.setCurrentChat(
                        username:
                            sameUser ? tile.recipientName : tile.senderName,
                        uidUser1: sameUser ? tile.senderId : tile.recipientId,
                        uidUser2: sameUser ? tile.recipientId : tile.senderId,
                        profilePicUrl:
                            sameUser ? tile.recipientPicUrl : tile.senderPicUrl,
                      );
                      context.router.pushNamed(ChatScreen.tag);
                    },
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
}
