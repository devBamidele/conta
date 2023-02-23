import 'package:auto_route/auto_route.dart';
import 'package:conta/view/home/persistent_tab.dart';
import 'package:conta/view/home/tab_views/message_view/chat_screen.dart';

@AdaptiveAutoRouter(
  routes: [
    AutoRoute(page: PersistentTab, initial: true),
    CustomRoute(
      path: ChatScreen.tag,
      page: ChatScreen,
      transitionsBuilder: TransitionsBuilders.slideLeft,
      durationInMilliseconds: 300,
    ),
  ],
)
class $AppRouter {}
