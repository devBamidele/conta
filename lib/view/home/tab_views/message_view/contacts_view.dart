import 'dart:developer';

import 'package:conta/view_model/chat_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../../models/Person.dart';
import '../../../../res/color.dart';
import '../../../../res/components/contact_tile.dart';
import '../../../../res/components/contacts_app_bar.dart';
import '../../../../res/components/empty/empty.dart';
import '../../../../utils/app_router/router.dart';
import '../../../../utils/app_router/router.gr.dart';

class ContactsView extends StatefulWidget {
  const ContactsView({super.key});

  @override
  State<ContactsView> createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
  bool isNavigating = false;

  Future<void> refresh() async {
    return Future.delayed(
      const Duration(seconds: 3),
      () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ContactsAppBar(),
      body: Consumer<ChatProvider>(
        builder: (_, data, __) {
          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primaryShadeColor,
                  onRefresh: refresh,
                  child: FutureBuilder<List<Person>>(
                    future: data.findAppUsersFromContact(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final personList = snapshot.data!;
                        if (personList.isEmpty) {
                          return const Center(
                            child: Empty(),
                          );
                        }
                        return ListView.builder(
                          itemCount: personList.length,
                          itemBuilder: (context, index) {
                            Person person = personList[index];
                            return ContactTile(
                              person: person,
                              onTap: () => onTileTap(data, person),
                              isSamePerson: person.id == currentUser,
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        log('Error fetching chat tiles: ${snapshot.error}');
                        return const Text('Sorry, try again later');
                      } else {
                        return Center(
                          child: LoadingAnimationWidget.threeArchedCircle(
                            color: AppColors.primaryShadeColor,
                            size: 48,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void navigateToNextScreen(BuildContext context) {
    if (!isNavigating) {
      isNavigating = true;
      navReplace(context, const ChatScreenRoute())
          // Reset the flag when the navigation is complete
          .then((_) => isNavigating = false);
    }
  }

  void onTileTap(ChatProvider data, Person person) {
    data.setCurrentChat(
      username: person.username,
      uidUser1: currentUser,
      uidUser2: person.id,
      profilePicUrl: person.profilePicUrl,
    );

    data.cancelReplyAndClearCache();
    navigateToNextScreen(context);
  }
}
