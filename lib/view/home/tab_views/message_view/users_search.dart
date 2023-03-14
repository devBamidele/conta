import 'package:auto_route/auto_route.dart';
import 'package:conta/models/Person.dart';
import 'package:conta/res/components/search_tile.dart';
import 'package:conta/res/components/user_tile.dart';
import 'package:conta/view/home/tab_views/message_view/chat_screen.dart';
import 'package:conta/view_model/chat_messages_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../../models/search_user.dart';
import '../../../../res/color.dart';

class UsersSearch extends SearchDelegate {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      // When the cancel icon is pressed
      Visibility(
        visible: query.isNotEmpty,
        child: IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(
            Icons.clear_rounded,
            size: 24,
            color: AppColors.opaqueTextColor,
          ),
        ),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // When the back button is pressed
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(
        IconlyLight.arrow_left,
        size: 24,
        color: AppColors.opaqueTextColor,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Consumer<ChatMessagesProvider>(
      builder: (_, data, Widget? child) {
        return StreamBuilder(
          stream: data.getSuggestionsStream(query),
          builder: (
            context,
            AsyncSnapshot<List<Person>> snapshot,
          ) {
            if (snapshot.hasData) {
              final suggestions = snapshot.data!;
              if (suggestions.isEmpty) {
                return const Center(
                  child: Text('Empty'),
                );
              }
              return ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final user = suggestions[index];
                  return UserTile(user: user);
                },
              );
            } else if (snapshot.hasError) {
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

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer<ChatMessagesProvider>(
      builder: (_, data, Widget? child) {
        return query.isEmpty
            ? StreamBuilder(
                stream: data.getRecentSearches(),
                builder: (
                  context,
                  AsyncSnapshot<List<SearchUser>> snapshot,
                ) {
                  if (snapshot.hasData) {
                    final searchChats = snapshot.data!;
                    if (searchChats.isEmpty) {
                      return const Center(
                        child: Text('No Recent Searches'),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 18,
                            right: 18,
                            top: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Text(
                                  'Recent searches',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: searchChats.length > 1,
                                child: GestureDetector(
                                  onTap: () => data.clearRecentSearch(),
                                  child: const Padding(
                                    padding: EdgeInsets.only(
                                      top: 10,
                                      left: 10,
                                      bottom: 10,
                                    ),
                                    child: Text(
                                      'Clear All',
                                      style: TextStyle(
                                        color: AppColors.opaqueTextColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: AnimatedList(
                            key: _listKey,
                            initialItemCount: searchChats.length,
                            itemBuilder: (context, index, animation) {
                              final searchUser = searchChats[index];
                              return buildSlideTransition(
                                animation: animation,
                                child: SearchTile(
                                  user: searchUser,
                                  onCancelTap: () {
                                    removeItem(context, index, searchChats);
                                  },
                                  onTileTap: () {
                                    data.setCurrentChat(
                                      username: searchUser.username,
                                      uidUser1: currentUser!.uid,
                                      uidUser2: searchUser.uidSearch,
                                      profilePicUrl: searchUser.profilePicUrl,
                                      tokenId: searchUser.tokenId,
                                    );
                                    navigateToChat(context);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
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
              )
            // When the User starts tying ( The Search Query is not empty )
            : StreamBuilder(
                stream: data.getSuggestionsStream(query),
                builder: (
                  context,
                  AsyncSnapshot<List<Person>> snapshot,
                ) {
                  if (snapshot.hasData) {
                    final suggestions = snapshot.data!;
                    if (suggestions.isEmpty) {
                      return const Center(
                        child: Text('Empty'),
                      );
                    }
                    return ListView.builder(
                      itemCount: suggestions.length,
                      itemBuilder: (context, index) {
                        final user = suggestions[index];
                        return UserTile(
                          user: user,
                          onTap: () {
                            data.addToRecentSearch(person: user);
                            data.setCurrentChat(
                              username: user.username,
                              uidUser1: currentUser!.uid,
                              uidUser2: user.id,
                              profilePicUrl: user.profilePicUrl,
                              tokenId: user.tokenId,
                            );
                            navigateToChat(context);
                          },
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
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

  navigateToChat(BuildContext context) {
    context.router.pushNamed(ChatScreen.tag);
  }

  Widget buildSlideTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ),
      ),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
        ),
        child: child,
      ),
    );
  }

  void removeItem(
    BuildContext context,
    int index,
    List<SearchUser> searchChats,
  ) {
    final chatProvider =
        Provider.of<ChatMessagesProvider>(context, listen: false);
    final user = searchChats[index];

    // Remove the item from the list
    searchChats.removeAt(index);
    chatProvider.deleteFromRecentSearch(username: user.username);

    // Animate the item removal
    _listKey.currentState!.removeItem(
      index,
      (context, animation) => buildSlideTransition(
        animation: animation,
        child: SearchTile(
          user: user,
          onCancelTap: () {},
        ),
      ),
      duration: const Duration(milliseconds: 500),
    );
  }
}
