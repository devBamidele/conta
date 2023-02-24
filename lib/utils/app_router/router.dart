import 'package:auto_route/auto_route.dart';
import 'package:conta/view/authentication/sign_up_screen.dart';
import 'package:conta/view/home/persistent_tab.dart';
import 'package:conta/view/home/tab_views/message_view/chat_screen.dart';

@AdaptiveAutoRouter(
  routes: [
    AutoRoute(page: SignUpScreen, initial: true),
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
