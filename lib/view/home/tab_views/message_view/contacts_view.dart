import 'package:conta/res/style/app_text_style.dart';
import 'package:conta/utils/widget_functions.dart';
import 'package:conta/view_model/contacts_provider.dart';
import 'package:conta/view_model/messages_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../../models/search_results.dart';
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
  bool showMore = true;
  bool showGlobalSearch = false;

  show(bool value) {
    if (showGlobalSearch == value) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        showGlobalSearch = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const ContactsAppBar(),
      body: Consumer2<MessagesProvider, ContactsProvider>(
        builder: (_, data, info, __) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<Set<SearchResults>>(
                initialData: info.initialContactData.isNotEmpty
                    ? info.initialContactData
                    : null,
                stream: info.fetchContacts(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final personList = snapshot.data!;

                    show(personList.length < 4);

                    if (personList.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text('No matching contacts found'),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20, top: 16),
                          child: Text(
                            'People you may know',
                            style: AppTextStyles.contactText,
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: personList.length,
                          itemBuilder: (context, index) {
                            final person = personList.elementAt(index);
                            return ContactTile(
                              person: person,
                              onTap: () => onTileTap(
                                  data: data, info: info, person: person),
                              isSamePerson: person.id == currentUser,
                            );
                          },
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    show(true);

                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text('Sorry, try again later'),
                      ),
                    );
                  } else {
                    show(false);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: LoadingAnimationWidget.threeArchedCircle(
                          color: AppColors.primaryShadeColor,
                          size: 32,
                        ),
                      ),
                    );
                  }
                },
              ),
              if (showGlobalSearch &&
                  info.contactFilter != null &&
                  info.contactFilter!.length < 10 &&
                  info.contactFilter!.isNotEmpty)
                StreamBuilder<List<SearchResults>>(
                  stream: info.searchMetadata(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox.shrink();
                    }
                    final personList = snapshot.data!;
                    return personList.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  top: 12,
                                  right: 20,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                        addWidth(6),
                                        SvgPicture.asset(
                                          'assets/images/logo.svg',
                                          fit: BoxFit.scaleDown,
                                          height: 17,
                                          colorFilter: const ColorFilter.mode(
                                            AppColors.algoliaColor,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: personList.length,
                                itemBuilder: (context, index) {
                                  final person = personList[index];
                                  return ContactTile(
                                    person: person,
                                    onTap: () => onTileTap(
                                        data: data, info: info, person: person),
                                    isSamePerson: person.id == currentUser,
                                  );
                                },
                              ),
                            ],
                          )
                        : const SizedBox.shrink();
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

  void onTileTap({
    required MessagesProvider data,
    required ContactsProvider info,
    required SearchResults person,
  }) {
    data.setCurrentChat(
      username: person.username,
      uidUser1: currentUser,
      uidUser2: person.id,
      profilePicUrl: person.profilePicUrl,
      bio: person.bio,
      notifications: true,
    );

    data.updateOppIndex();

    info.clearContactsFilter();

    data.cancelReplyAndClearCache();

    navigateToNextScreen(context);
  }
}
