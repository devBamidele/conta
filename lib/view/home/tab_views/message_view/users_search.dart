import 'package:conta/res/components/search_item.dart';
import 'package:conta/view_model/chat_messages_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../../models/search_user.dart';
import '../../../../res/color.dart';

class UsersSearch extends SearchDelegate {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

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
            AsyncSnapshot<List<String>> snapshot,
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
                  final name = suggestions[index];
                  return ListTile(
                    title: Text(name),
                    onTap: () {
                      data.addToRecentSearch(name: name);
                      query = name;
                      showResults(context);
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
                    final searchUsers = snapshot.data!;
                    if (searchUsers.isEmpty) {
                      return const Center(
                        child: Text('No Recent Searches'),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 18, top: 20, bottom: 5),
                          child: Text(
                            'Recent searches',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                        ),
                        Expanded(
                          child: AnimatedList(
                            key: _listKey,
                            initialItemCount: searchUsers.length,
                            itemBuilder: (context, index, animation) {
                              final searchUser = searchUsers[index];
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: SearchItem(
                                  user: searchUser,
                                  onCancelTap: () {
                                    removeItem(
                                      index: index,
                                      name: searchUser.name,
                                      context: context,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        Visibility(
                          visible: searchUsers.length > 1,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 18,
                              bottom: 16,
                            ),
                            child: GestureDetector(
                              onTap: () => data.clearRecentSearch(),
                              child: const Text(
                                'Clear recent searches',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
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
                  AsyncSnapshot<List<String>> snapshot,
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
                        final name = suggestions[index];
                        return ListTile(
                          title: Text(name),
                          onTap: () {
                            data.addToRecentSearch(name: name);
                            query = name;
                            showResults(context);
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

  void removeItem({
    required int index,
    required String name,
    required BuildContext context,
  }) {
    Provider.of<ChatMessagesProvider>(context, listen: false)
        .deleteFromRecentSearch(name: name);
    _listKey.currentState!.removeItem(
      index,
      (context, animation) => const SizedBox(
        width: 0,
        height: 0,
      ),
      duration: const Duration(milliseconds: 500),
    );
  }
}
