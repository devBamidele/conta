import 'package:conta/models/Person.dart';
import 'package:conta/res/components/search_tile.dart';
import 'package:conta/res/components/user_tile.dart';
import 'package:conta/res/style/app_text_style.dart';
import 'package:conta/utils/app_router/router.dart';
import 'package:conta/utils/app_router/router.gr.dart';
import 'package:conta/view_model/chat_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/search_user.dart';
import '../../../../utils/widget_functions.dart';
import '../../../../view_model/search_provider.dart';

class UsersSearch extends SearchDelegate {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      // When the cancel icon is pressed
      Visibility(
        visible: query.isNotEmpty,
        child: IconButton(
          onPressed: () => query = '',
          icon: clearIcon(),
        ),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // When the back button is pressed
    return IconButton(
      onPressed: () => close(context, null),
      icon: returnArrow(),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (_, searchData, Widget? child) {
        return Consumer<ChatProvider>(
          builder: (_, chatData, Widget? child) {
            return StreamBuilder(
              stream: searchData.getSuggestionsStream(query, currentUserId),
              builder: (context, AsyncSnapshot<List<Person>> snapshot) {
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
                          onUserTileTap(
                            context,
                            searchData: searchData,
                            chatData: chatData,
                            user: user,
                          );
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return const Text('Sorry, try again later');
                } else {
                  return loadRotatingDots();
                }
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (_, searchData, Widget? child) {
        return Consumer<ChatProvider>(
          builder: (_, chatData, Widget? child) {
            return query.isEmpty
                ? StreamBuilder(
                    stream: searchData.getRecentSearches(),
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
                                top: 8,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Text(
                                      'Recent searches',
                                      style: AppTextStyles.headlineMedium,
                                    ),
                                  ),
                                  Visibility(
                                    visible: searchChats.length > 1,
                                    child: GestureDetector(
                                      onTap: () =>
                                          searchData.clearRecentSearch(),
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                          top: 10,
                                          left: 10,
                                          bottom: 10,
                                        ),
                                        child: Text(
                                          'Clear All',
                                          style: AppTextStyles.headlineSmall,
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
                                      onCancelTap: () => removeItem(
                                        searchData,
                                        index,
                                        searchChats,
                                      ),
                                      onTileTap: () {
                                        onSearchTileTap(
                                          context,
                                          chatData: chatData,
                                          searchUser: searchUser,
                                        );
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
                        return loadRotatingDots();
                      }
                    },
                  )
                // When the User starts tying ( The Search Query is not empty )
                : StreamBuilder(
                    stream:
                        searchData.getSuggestionsStream(query, currentUserId),
                    builder: (
                      context,
                      AsyncSnapshot<List<Person>> snapshot,
                    ) {
                      if (snapshot.hasData) {
                        final suggestions = snapshot.data!;
                        if (suggestions.isEmpty) {
                          return const Center(
                            child: Text('User not found'),
                          );
                        }
                        return ListView.builder(
                          itemCount: suggestions.length,
                          itemBuilder: (context, index) {
                            final user = suggestions[index];
                            return UserTile(
                              user: user,
                              onTap: () {
                                onUserTileTap(
                                  context,
                                  searchData: searchData,
                                  chatData: chatData,
                                  user: user,
                                );
                              },
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return const Text('Sorry, try again later');
                      } else {
                        return loadRotatingDots();
                      }
                    },
                  );
          },
        );
      },
    );
  }

  navigateToChat(BuildContext context) {
    navPush(context, const ChatScreenRoute());
  }

  void onUserTileTap(
    BuildContext context, {
    required SearchProvider searchData,
    required ChatProvider chatData,
    required Person user,
  }) {
    searchData.addToRecentSearch(person: user);
    chatData.setCurrentChat(
      username: user.username,
      uidUser1: currentUserId,
      uidUser2: user.id,
      profilePicUrl: user.profilePicUrl,
    );
    navigateToChat(context);
  }

  void onSearchTileTap(
    BuildContext context, {
    required ChatProvider chatData,
    required SearchUser searchUser,
  }) {
    chatData.setCurrentChat(
      username: searchUser.username,
      uidUser1: currentUserId,
      uidUser2: searchUser.uidSearch,
      profilePicUrl: searchUser.profilePicUrl,
    );
    navigateToChat(context);
  }

  void removeItem(
    SearchProvider data,
    int index,
    List<SearchUser> searchChats,
  ) {
    final user = searchChats[index];

    // Remove the item from the list
    searchChats.removeAt(index);
    data.deleteFromRecentSearch(username: user.username);

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

// Todo : Get lottie animation for 'Empty' state
