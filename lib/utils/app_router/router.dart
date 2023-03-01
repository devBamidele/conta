import 'package:auto_route/auto_route.dart';
import 'package:conta/view/authentication/forgot_password_screen.dart';
import 'package:conta/view/authentication/login_screen.dart';
import 'package:conta/view/authentication/sign_up_screen.dart';
import 'package:conta/view/home/persistent_tab.dart';
import 'package:conta/view/home/tab_views/message_view/chat_screen.dart';

import '../../view/account_setup/set_name_screen.dart';
import '../../view/account_setup/set_photo_page.dart';

@AdaptiveAutoRouter(
  routes: [
    AutoRoute(page: SignUpScreen, initial: true),
    AutoRoute(page: SetNameScreen, path: SetNameScreen.tag),
    AutoRoute(page: SetPhotoScreen, path: SetPhotoScreen.tag),

    // Authentication screens
    //AutoRoute(page: SignUpScreen, path: SignUpScreen.tag),
    AutoRoute(page: ForgotPasswordScreen, path: ForgotPasswordScreen.tag),
    AutoRoute(page: LoginScreen, path: LoginScreen.tag),

    AutoRoute(page: PersistentTab, path: PersistentTab.tag),
    CustomRoute(
      path: ChatScreen.tag,
      page: ChatScreen,
      transitionsBuilder: TransitionsBuilders.slideLeft,
      durationInMilliseconds: 300,
    ),
  ],
)
class $AppRouter {}
