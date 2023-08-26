import 'package:conta/res/components/profile/logout_sheet.dart';
import 'package:conta/utils/app_router/router.dart';
import 'package:conta/utils/app_router/router.gr.dart';
import 'package:conta/utils/widget_functions.dart';
import 'package:conta/view/account_setup/set_photo_page.dart';
import 'package:conta/view_model/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../res/color.dart';
import '../../../res/components/custom/custom_back_button.dart';
import '../../../res/components/profile/delete_account_sheet.dart';
import '../../../res/components/profile/profile_pic.dart';
import '../../../res/components/profile/profile_tile.dart';
import '../../../res/style/component_style.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: pagePadding.copyWith(bottom: 10),
          child: SingleChildScrollView(
            child: Consumer<UserProvider>(
              builder: (_, data, Widget? child) {
                return Column(
                  children: [
                    const Row(
                      children: [
                        CustomBackButton(
                          padding: EdgeInsets.only(top: 20),
                          color: AppColors.extraTextColor,
                        ),
                      ],
                    ),
                    addHeight(15),
                    Stack(
                      children: [
                        const Hero(
                          tag: 'Avatar',
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            child: ProfilePic(noPicSize: 42),
                          ),
                        ),
                        UploadPhotoWidget(
                          onTap: () {},
                          bottom: 0,
                          right: 0,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          Text(
                            data.userData!.username,
                            style: const TextStyle(
                                fontSize: 20, color: AppColors.blackColor),
                          ),
                          Text(
                            data.userData!.bio,
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.blackColor.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            ProfileTile(
                              titleText: 'Name',
                              icon: IconlyLight.profile,
                              subtitle: data.userData!.name,
                            ),
                            ProfileTile(
                              titleText: 'Username',
                              icon: Icons.alternate_email_rounded,
                              subtitle: data.userData!.username,
                            ),
                            ProfileTile(
                              titleText: 'Bio',
                              icon: IconlyLight.chat,
                              subtitle: data.userData!.bio,
                              onTap: () =>
                                  navPush(context, const EditBioScreenRoute()),
                            ),
                            ProfileTile(
                              titleText: 'Email',
                              icon: IconlyLight.message,
                              subtitle: data.userData!.email,
                            ),
                            ProfileTile(
                              titleText: 'Password',
                              icon: IconlyLight.lock,
                              onTap: () => navPush(
                                  context, const EditPasswordScreenRoute()),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0, bottom: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            ProfileTile(
                              onTap: () => navPush(
                                  context, const BlockedContactsScreenRoute()),
                              titleText: 'Blocked accounts',
                              icon: Icons.block_rounded,
                              leadingColor: AppColors.primaryShadeColor,
                            ),
                            ProfileTile(
                              onTap: () => showLogoutSheet(context),
                              titleText: 'Logout',
                              icon: IconlyLight.logout,
                              leadingColor: AppColors.primaryShadeColor,
                              showTrailing: false,
                            ),
                            ProfileTile(
                              onTap: () => showDeleteAccountSheet(context),
                              titleText: 'Delete account',
                              icon: IconlyLight.delete,
                              leadingColor: AppColors.primaryShadeColor,
                              showTrailing: false,
                            ),
                          ],
                        ), //
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

void showLogoutSheet(BuildContext context) {
  showModalBottomSheet<void>(
    isScrollControlled: true,
    clipBehavior: Clip.hardEdge,
    context: context,
    builder: (BuildContext sheetContext) {
      return LogoutSheet();
    },
  );
}

void showDeleteAccountSheet(BuildContext context) {
  showModalBottomSheet<void>(
    isScrollControlled: true,
    clipBehavior: Clip.hardEdge,
    context: context,
    builder: (BuildContext sheetContext) {
      return const DeleteAccountSheet();
    },
  );
}
