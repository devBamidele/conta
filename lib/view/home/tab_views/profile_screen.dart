import 'package:conta/utils/app_router/router.dart';
import 'package:conta/utils/app_router/router.gr.dart';
import 'package:conta/utils/widget_functions.dart';
import 'package:conta/view/account_setup/set_photo_page.dart';
import 'package:conta/view_model/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../../res/color.dart';
import '../../../res/components/confirmation_dialog.dart';
import '../../../res/components/custom/custom_back_button.dart';
import '../../../res/components/profile/delete_account_sheet.dart';
import '../../../res/components/profile/profile_pic.dart';
import '../../../res/components/profile/profile_tile.dart';
import '../../../res/style/component_style.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AuthService _authService = AuthService();

  logout() {
    _authService.signOutFromApp();

    navReplaceAll(
      context,
      [const LoginScreenRoute()],
    );

    AppUtils.showSnackbar('Logged out Successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: pagePadding,
          child: Consumer<UserProvider>(
            builder: (_, data, Widget? child) {
              return Stack(
                children: [
                  Column(
                    children: [
                      const Row(
                        children: [
                          CustomBackButton(
                            padding: EdgeInsets.only(top: 20),
                          ),
                        ],
                      ),
                      addHeight(15),
                      Stack(
                        children: [
                          Hero(
                            tag: 'Avatar',
                            child: UrlProfilePicture(
                                imageUrl: data.userData?.profilePicUrl),
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
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              data.userData!.bio,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black.withOpacity(0.8),
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
                          child: const Column(
                            children: [
                              ProfileTile(
                                titleText: 'Name',
                                leading: Icon(IconlyLight.profile),
                              ),
                              ProfileTile(
                                titleText: 'Username',
                                leading: Icon(Icons.alternate_email_rounded),
                              ),
                              ProfileTile(
                                titleText: 'Bio',
                                leading: Icon(IconlyLight.chat),
                              ),
                              ProfileTile(
                                titleText: 'Email',
                                leading: Icon(IconlyLight.message),
                              ),
                              ProfileTile(
                                titleText: 'Password',
                                leading: Icon(IconlyLight.lock),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          ProfileTile(
                            onTap: () => confirmLogout(context, logout),
                            titleText: 'Logout',
                            leading: const Icon(
                              IconlyLight.logout,
                              color: AppColors.primaryShadeColor,
                            ),
                          ),
                          ProfileTile(
                            onTap: () => showDeleteAccountSheet(context),
                            titleText: 'Delete account',
                            leading: const Icon(
                              IconlyLight.delete,
                              color: AppColors.primaryShadeColor,
                            ),
                          ),
                        ],
                      ), //
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

void confirmLogout(BuildContext context, VoidCallback action) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ConfirmationDialog(
        title: 'Logout',
        validateText: 'Yes, Logout',
        contentText: 'Are you sure you want to logout ?',
        onConfirmPressed: action,
      );
    },
  );
}

void showDeleteAccountSheet(BuildContext context) {
  showModalBottomSheet<void>(
    isScrollControlled: true,
    clipBehavior: Clip.hardEdge,
    context: context,
    builder: (BuildContext sheetContext) {
      return DeleteAccountSheet();
    },
  );
}
