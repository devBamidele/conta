import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/chat.dart';
import '../../../res/color.dart';
import '../../../res/components/app_bar_icon.dart';
import '../../../res/components/chat_list_tile.dart';
import '../../../res/components/custom/custom_back_button.dart';
import '../../../res/components/empty/empty.dart';
import '../../../utils/app_router/router.dart';
import '../../../utils/app_router/router.gr.dart';
import '../../../utils/widget_functions.dart';
import '../../../view_model/chat_provider.dart';
import '../../../view_model/messages_provider.dart';

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
        body: Consumer<ChatProvider>(
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
                          return Center(
                            child: Empty(
                              value: data.filter,
                              customMessage: 'Blocked chats will appear here',
                            ),
                          );
                        }
                        return Consumer<MessagesProvider>(
                          builder: (_, info, __) {
                            return buildChatList(info, tileData);
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

class BlockedAccountsAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  const BlockedAccountsAppBar({super.key});

  @override
  State<BlockedAccountsAppBar> createState() => _BlockedAccountsAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(58);
}

class _BlockedAccountsAppBarState extends State<BlockedAccountsAppBar> {
  bool _isSearchModeActive = false;

  void _toggleSearchMode() {
    setState(() => _isSearchModeActive = !_isSearchModeActive);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MessagesProvider>(
      builder: (_, data, __) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: _isSearchModeActive
              ? AppBar(
                  key: const ValueKey<bool>(true),
                  leading: const CustomBackButton(
                    color: AppColors.hintTextColor,
                    size: 24,
                    padding: EdgeInsets.only(left: 16),
                  ),
                  title: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        hintText: 'Search ...',
                      ),
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: GestureDetector(
                        onTap: _toggleSearchMode,
                        child: const AppBarIcon(
                          icon: Icons.close,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                )
              : AppBar(
                  key: const ValueKey<bool>(false),
                  leading: const CustomBackButton(
                    color: AppColors.hintTextColor,
                    size: 24,
                    padding: EdgeInsets.only(left: 16),
                  ),
                  title: const Column(
                    children: [
                      Text(
                        'Blocked chats',
                        style: TextStyle(
                          color: AppColors.blackColor,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: GestureDetector(
                        onTap: _toggleSearchMode,
                        child: searchIcon(),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
