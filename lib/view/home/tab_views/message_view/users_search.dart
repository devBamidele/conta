import 'package:conta/view_model/chat_messages_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../../models/search_user.dart';
import '../../../../res/color.dart';

class UsersSearch extends SearchDelegate {
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
                        child: Text('Empty'),
                      );
                    }
                    return ListView.builder(
                      itemCount: searchUsers.length,
                      itemBuilder: (context, index) {
                        final searchUser = searchUsers[index];
                        return ListTile(
                          title: Text(searchUser.name),
                          trailing: IconButton(
                            onPressed: () {
                              data.deleteFromRecentSearch(
                                  name: searchUser.name);
                              // Delete the item from recent search
                            },
                            icon: const Icon(
                              Icons.clear_rounded,
                              size: 24,
                              color: AppColors.opaqueTextColor,
                            ),
                          ),
                          onTap: () {
                            // Navigate to a screen to start a chat with the selected user
                            query = searchUser.name;
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
}
