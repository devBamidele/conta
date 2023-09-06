import 'dart:developer';

import 'package:conta/res/style/app_text_style.dart';
import 'package:conta/utils/widget_functions.dart';
import 'package:conta/view_model/chat_provider.dart';
import 'package:conta/view_model/messages_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../../models/Person.dart';
import '../../../../res/color.dart';
import '../../../../res/components/app_bars/contacts_app_bar.dart';
import '../../../../res/components/contact_tile.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const ContactsAppBar(),
      body: Consumer2<MessagesProvider, ChatProvider>(
        builder: (_, data, info, __) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<List<Person>>(
                stream: info.findAppUsersFromContact(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final personList = snapshot.data!;

                    if (personList.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20, top: 20),
                          child: Text(
                            'Contacts on Conta',
                            style: AppTextStyles.contactText,
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: personList.length,
                          itemBuilder: (context, index) {
                            Person person = personList[index];
                            return ContactTile(
                              person: person,
                              onTap: () => onTileTap(data, person),
                              isSamePerson: person.id == currentUser,
                            );
                          },
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    log('Error fetching chat tiles: ${snapshot.error}');
                    return const Text('Sorry, try again later');
                  } else {
                    return Center(
                      //
                      child: LoadingAnimationWidget.threeArchedCircle(
                        color: AppColors.primaryShadeColor,
                        size: 48,
                      ),
                    );
                  }
                },
              ),
              StreamBuilder<List<Person>>(
                stream: info.findAppUsersNotInContacts(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final personList = snapshot.data!;
                    if (personList.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                            top: info.emptyContacts ? 16 : 4,
                            right: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Global search',
                                style: AppTextStyles.contactText,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Search with',
                                    style: AppTextStyles.contactText,
                                  ),
                                  addWidth(4),
                                  Image.asset(
                                    'assets/images/algolia.png',
                                    scale: 58,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: personList.length,
                          itemBuilder: (context, index) {
                            Person person = personList[index];
                            return ContactTile(
                              person: person,
                              onTap: () => onTileTap(data, person),
                              isSamePerson: person.id == currentUser,
                            );
                          },
                        ),
                      ],
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

  void onTileTap(MessagesProvider data, Person person) {
    data.setCurrentChat(
      username: person.username,
      uidUser1: currentUser,
      uidUser2: person.id,
      profilePicUrl: person.profilePicUrl,
      bio: person.bio,
      name: person.name,
      notifications: true,
    );

    data.updateOppIndex();

    data.cancelReplyAndClearCache();
    navigateToNextScreen(context);
  }
}
