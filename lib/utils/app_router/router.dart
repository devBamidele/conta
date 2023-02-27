import 'package:auto_route/auto_route.dart';
import 'package:conta/view/authentication/forgot_password_screen.dart';
import 'package:conta/view/authentication/login_screen.dart';
import 'package:conta/view/authentication/sign_up_screen.dart';
import 'package:conta/view/home/persistent_tab.dart';
import 'package:conta/view/home/tab_views/message_view/chat_screen.dart';

@AdaptiveAutoRouter(
  routes: [
    AutoRoute(page: LoginScreen, initial: true),
    AutoRoute(page: SignUpScreen, path: SignUpScreen.tag),
    AutoRoute(page: ForgotPasswordScreen, path: ForgotPasswordScreen.tag),
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
