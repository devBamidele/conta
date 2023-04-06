import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:conta/res/components/chat_list_tile.dart';
import 'package:conta/view_model/chat_messages_provider.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../../models/chat_tile_data.dart';
import '../../../../res/color.dart';
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
                  return ChatListTile(
                    tileData: tile,
                    onTileTap: () {
                      data.setCurrentChat(
                        username: tile.userName,
                        uidUser1: data.currentUser!.uid,
                        uidUser2: tile.userId,
                        profilePicUrl: tile.profilePicUrl,
                      );
                      context.router.pushNamed(ChatScreen.tag);
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              log('Error fetching chat tiles: ${snapshot.error}');
              return const Text('Sorry, try again later');
            } else {
              return Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: AppColors.primaryShadeColor,
                  size: 50,
                ),
              );
            }
          },
        );
      },
    );
  }
}
