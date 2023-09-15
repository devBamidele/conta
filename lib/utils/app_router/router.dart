import 'package:auto_route/auto_route.dart';
import 'package:conta/view/account_setup/sign_up_screen.dart';
import 'package:conta/view/account_setup/verify_account_screen.dart';
import 'package:conta/view/authentication/login_screen.dart';
import 'package:conta/view/authentication/recover_password_screen.dart';
import 'package:conta/view/authentication/update_password_screen.dart';
import 'package:conta/view/home/home_screen.dart';
import 'package:conta/view/home/intermediary.dart';
import 'package:conta/view/home/profile_view/edit_profile_info/edit_username_screen.dart';
import 'package:conta/view/home/profile_view/file_image_preview.dart';
import 'package:conta/view/home/profile_view/profile_image_preview.dart';
import 'package:conta/view/home/profile_view/profile_screen.dart';
import 'package:conta/view/home/tab_views/message_view/chat_screen.dart';
import 'package:conta/view/home/tab_views/message_view/contacts_view.dart';
import 'package:conta/view/home/tab_views/message_view/preview_screen.dart';
import 'package:flutter/material.dart';

import '../../res/components/image_views/view_image_screen.dart';
import '../../view/account_setup/set_name_screen.dart';
import '../../view/account_setup/set_photo_page.dart';
import '../../view/home/profile_view/blocked_contacts_screen.dart';
import '../../view/home/profile_view/edit_profile_info/edit_bio_screen.dart';
import '../../view/home/profile_view/edit_profile_info/edit_password_screen.dart';
import '../../view/onboard/splash_screen.dart';

@AdaptiveAutoRouter(
  routes: [
    AutoRoute(page: SplashScreen, initial: true),

    AutoRoute(page: SetNameScreen),
    AutoRoute(page: SetPhotoScreen),
    AutoRoute(page: VerifyAccountScreen),

    // Authentication screens
    AutoRoute(page: SignUpScreen),
    AutoRoute(page: RecoverPasswordScreen),
    AutoRoute(page: LoginScreen),
    AutoRoute(page: UpdatePasswordScreen),

    AutoRoute(page: Intermediary),

    AutoRoute(page: PreviewScreen),
    AutoRoute(page: ViewImageScreen),

    AutoRoute(page: ProfileScreen),

    AutoRoute(page: HomeScreen),
    AutoRoute(page: ChatScreen),

    AutoRoute(page: ContactsView),

    CustomRoute(
      page: BlockedContactsScreen,
      transitionsBuilder: TransitionsBuilders.slideLeft,
      durationInMilliseconds: 150,
      reverseDurationInMilliseconds: 150,
    ),

    CustomRoute(
      page: EditBioScreen,
      transitionsBuilder: TransitionsBuilders.slideLeft,
      durationInMilliseconds: 150,
      reverseDurationInMilliseconds: 150,
    ),

    CustomRoute(
      page: EditPasswordScreen,
      transitionsBuilder: TransitionsBuilders.slideLeft,
      durationInMilliseconds: 150,
      reverseDurationInMilliseconds: 150,
    ),

    CustomRoute(
      page: EditUsernameScreen,
      transitionsBuilder: TransitionsBuilders.slideLeft,
      durationInMilliseconds: 150,
      reverseDurationInMilliseconds: 150,
    ),

    AutoRoute(page: ProfileImagePreview),

    AutoRoute<bool?>(page: FileImagePreview),
  ],
)
class $AppRouter {}

Future<void> navPush(
    BuildContext context, PageRouteInfo<dynamic>? route) async {
  await context.router.push(route!);
}

bool isRoot(BuildContext context) => context.router.isRoot;

Future<void> navReplaceAll(
  BuildContext context,
  List<PageRouteInfo<dynamic>> routes,
) async {
  await context.router.replaceAll(routes);
}

Future<void> navReplace(
    BuildContext context, PageRouteInfo<dynamic> route) async {
  await context.router.replace(route);
}
