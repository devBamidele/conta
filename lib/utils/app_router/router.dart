import 'package:auto_route/auto_route.dart';
import 'package:conta/res/components/image_preview/media_preview_screen.dart';
import 'package:conta/view/account_setup/sign_up_screen.dart';
import 'package:conta/view/account_setup/verify_account_screen.dart';
import 'package:conta/view/authentication/login_screen.dart';
import 'package:conta/view/authentication/recover_password_screen.dart';
import 'package:conta/view/authentication/resend_reset_email.dart';
import 'package:conta/view/home/persistent_tab.dart';
import 'package:conta/view/home/tab_views/message_view/chat_screen.dart';
import 'package:conta/view/home/tab_views/message_view/preview_screen.dart';
import 'package:flutter/cupertino.dart';

import '../../view/account_setup/set_name_screen.dart';
import '../../view/account_setup/set_photo_page.dart';
import '../../view/onboard/splash_screen.dart';

@AdaptiveAutoRouter(
  routes: [
    AutoRoute(page: SplashScreen, initial: true),

    AutoRoute(page: SetNameScreen),
    AutoRoute(page: SetPhotoScreen, path: SetPhotoScreen.tag),
    AutoRoute(page: VerifyAccountScreen, path: VerifyAccountScreen.tag),

    // Authentication screens
    AutoRoute(page: SignUpScreen),
    AutoRoute(page: RecoverPasswordScreen, path: RecoverPasswordScreen.tag),
    AutoRoute(page: LoginScreen),
    AutoRoute(page: ResendResetEmail),
    AutoRoute(page: PreviewScreen, path: PreviewScreen.tag),

    AutoRoute(page: MediaPreviewScreen),
    AutoRoute(page: PersistentTab, path: PersistentTab.tag),
    CustomRoute(
      path: ChatScreen.tag,
      page: ChatScreen,
      transitionsBuilder: TransitionsBuilders.slideLeft,
      durationInMilliseconds: 150,
    ),
  ],
)
class $AppRouter {}

void navPush(BuildContext context, PageRouteInfo<dynamic>? route) {
  context.router.push(route!);
}

bool isRoot(BuildContext context) => context.router.isRoot;

void navReplaceAll(
  BuildContext context,
  List<PageRouteInfo<dynamic>> routes,
) {
  context.router.replaceAll(routes);
}

void navReplace(BuildContext context, PageRouteInfo<dynamic> route) {
  context.router.replace(route);
}
