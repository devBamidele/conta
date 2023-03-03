import 'package:conta/view_model/chat_messages_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

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
        return FutureBuilder(
          future: data.getUsersMatchingFilter(query),
          builder: (context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.hasData) {
              final userNames = snapshot.data!;
              return ListView.builder(
                itemCount: userNames.length,
                itemBuilder: (context, index) {
                  final userName = userNames[index];
                  return ListTile(
                    title: Text(userName),
                    onTap: () {
                      // Navigate to a screen to start a chat with the selected user
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
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
        return StreamBuilder(
          stream: data.getAllUserNames(),
          builder: (context, AsyncSnapshot<List<String>> snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            final suggestions = snapshot.data!
                .where(
                    (name) => name.toLowerCase().contains(query.toLowerCase()))
                .toList();
            return ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final name = suggestions[index];
                return ListTile(
                  title: Text(name),
                  onTap: () {
                    query = name;
                    showResults(context);
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
