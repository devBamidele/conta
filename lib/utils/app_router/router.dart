import 'package:auto_route/auto_route.dart';
import 'package:conta/view/home/persistent_tab.dart';

@AdaptiveAutoRouter(
  routes: [
    AutoRoute(page: PersistentTab, initial: true),
  ],
)
class $AppRouter {}
