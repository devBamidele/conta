import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/chat.dart';
import '../../../res/color.dart';
import '../../../res/components/chat_list_tile.dart';
import '../../../res/components/custom/custom_back_button.dart';
import '../../../res/components/empty/empty.dart';
import '../../../utils/widget_functions.dart';
import '../../../view_model/messages_provider.dart';

class BlockedContactsScreen extends StatefulWidget {
  const BlockedContactsScreen({super.key});

  @override
  State<BlockedContactsScreen> createState() => _BlockedContactsScreenState();
}

class _BlockedContactsScreenState extends State<BlockedContactsScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BlockedAccountsAppBar(),
      body: Consumer<MessagesProvider>(
        builder: (_, data, __) {
          return Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: data.getBlockedChatStream(),
                  builder: (context, AsyncSnapshot<List<Chat>> snapshot) {
                    if (snapshot.hasData) {
                      final tileData = snapshot.data!;
                      if (tileData.isEmpty) {
                        return Center(child: Empty(value: data.filter));
                      }
                      return ListView.builder(
                        itemCount: tileData.length,
                        itemBuilder: (context, index) {
                          Chat tile = tileData[index];
                          bool sameUser = tile.lastSenderUserId == currentUser;
                          int oppIndex =
                              tile.participants.indexOf(currentUser) == 0
                                  ? 1
                                  : 0;

                          return ChatListTile(
                            tileData: tile,
                            onTileTap: () => {},
                            // onTileTap(data, tile, sameUser, oppIndex),
                            isSameUser: sameUser,
                            oppIndex: oppIndex,
                            samePerson:
                                tile.participants[0] == tile.participants[1],
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class BlockedAccountsAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  const BlockedAccountsAppBar({super.key});

  @override
  State<BlockedAccountsAppBar> createState() => _BlockedAccountsAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(58);
}

class _BlockedAccountsAppBarState extends State<BlockedAccountsAppBar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MessagesProvider>(
      builder: (_, data, __) {
        return AppBar(
          leading: const CustomBackButton(
            color: AppColors.hintTextColor,
            size: 24,
            padding: EdgeInsets.only(left: 16),
          ),
          title: const Text(
            'Blocked accounts',
            style: TextStyle(
              color: AppColors.blackColor,
            ),
          ),
        );
      },
    );
  }
}
