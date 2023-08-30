import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/chat.dart';
import '../../../../res/components/app_bars/blocked_app_bar.dart';
import '../../../../res/components/chat_list_tile.dart';
import '../../../../res/components/empty/empty.dart';
import '../../../../utils/app_router/router.dart';
import '../../../../utils/app_router/router.gr.dart';
import '../../../../utils/widget_functions.dart';
import '../../../../view_model/chat_provider.dart';
import '../../../../view_model/messages_provider.dart';

class BlockedContactsScreen extends StatefulWidget {
  const BlockedContactsScreen({super.key});

  @override
  State<BlockedContactsScreen> createState() => _BlockedContactsScreenState();
}

class _BlockedContactsScreenState extends State<BlockedContactsScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
  bool isNavigating = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const BlockedAccountsAppBar(),
        body: SafeArea(
          child: Consumer2<ChatProvider, MessagesProvider>(
            builder: (_, data, info, __) {
              return Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: data.getBlockedChatStream(),
                      builder: (context, AsyncSnapshot<List<Chat>> snapshot) {
                        if (snapshot.hasData) {
                          final tileData = snapshot.data!;
                          if (tileData.isEmpty) {
                            return Center(
                              child: Empty(
                                value: data.blockedFilter,
                                customMessage: 'Blocked chats will appear here',
                              ),
                            );
                          }
                          return buildChatList(info, tileData);
                        } else if (snapshot.hasError) {
                          log('Error fetching chat tiles: ${snapshot.error}');
                          return const Text('Sorry, try again later');
                        } else {
                          return shimmerTiles();
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildChatList(MessagesProvider info, List<Chat> tileData) {
    return ListView.builder(
      itemCount: tileData.length,
      itemBuilder: (context, index) {
        Chat tile = tileData[index];

        bool sameUser = tile.lastSenderUserId == currentUser;
        int oppIndex = tile.participants.indexOf(currentUser) == 0 ? 1 : 0;

        return ChatListTile(
          tileData: tile,
          onTileTap: () => onTileTap(info, tile, sameUser, oppIndex),
          isSameUser: sameUser,
          oppIndex: oppIndex,
          samePerson: tile.participants[0] == tile.participants[1],
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

  void onTileTap(
      MessagesProvider data, Chat tile, bool sameUser, int oppIndex) {
    data.setCurrentChat(
      username: tile.userNames[oppIndex],
      uidUser1: currentUser,
      uidUser2: tile.participants[oppIndex],
      profilePicUrl: tile.profilePicUrls[oppIndex],
    );

    data.cancelReplyAndClearCache();
    navigateToNextScreen(context);
  }
}
