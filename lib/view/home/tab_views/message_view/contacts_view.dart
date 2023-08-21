import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:conta/res/components/custom/custom_back_button.dart';
import 'package:conta/view_model/chat_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../../models/Person.dart';
import '../../../../res/color.dart';
import '../../../../res/components/empty.dart';
import '../../../../res/components/shimmer/shimmer_widget.dart';
import '../../../../res/style/component_style.dart';
import '../../../../utils/app_router/router.dart';
import '../../../../utils/app_router/router.gr.dart';
import '../../../../utils/widget_functions.dart';

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
      appBar: AppBar(
        leading: const CustomBackButton(
          color: AppColors.hintTextColor,
          size: 24,
          padding: EdgeInsets.only(left: 16),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: searchIcon(),
          ),
        ],
        title: const Column(
          children: [
            Text(
              'Select contact',
              style: TextStyle(
                color: AppColors.blackColor,
              ),
            ),
          ],
        ),
      ),
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
                            return SelectContactTile(
                              person: person,
                              onTap: () => onTileTap(data, person),
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

class SelectContactTile extends StatelessWidget {
  const SelectContactTile({
    super.key,
    required this.person,
    this.onTap,
  });

  final Person person;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 26,
        backgroundColor: Colors.white,
        child: _buildProfileImage(),
      ),
      title: _buildUsername(),
      contentPadding: tileContentPadding,
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: _buildBio(),
      ),
    );
  }

  Widget _buildBio() {
    return Text(
      person.bio,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(color: AppColors.extraTextColor),
    );
  }

  Widget _buildUsername() {
    return Text(
      person.username,
      style: const TextStyle(
        fontSize: 18,
        height: 1.2,
      ),
    );
  }

  Widget _buildProfileImage() {
    final imageUrl = person.profilePicUrl;

    return imageUrl != null
        ? CachedNetworkImage(
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) =>
                const ShimmerWidget.circular(width: 54, height: 54),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          )
        : noProfilePic();
  }
}
