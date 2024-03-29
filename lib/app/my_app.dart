import 'package:flutter/material.dart';

import '../main.dart';
import '../res/app_theme.dart';
import '../utils/app_router/router.gr.dart';
import '../utils/app_utils.dart';
import '../utils/services/auth_service.dart';

/// The main application widget.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  /// An instance of the [AuthService].
  late AuthService _authService;

  @override
  void initState() {
    super.initState();

    // Initialize the [AuthService].
    _authService = AuthService();

    // Register this object as an observer of the WidgetsBinding instance.
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Unregister this object as an observer of the WidgetsBinding instance.
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        // The app is now in the foreground.
        _authService.updateUserOnlineStatus(true);
        break;
      default:
        // The app is now in a background state or closed.
        _authService.updateUserOnlineStatus(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appRouter = getIt<AppRouter>();
    return MaterialApp.router(
      // Set the scaffold messenger key to the AppUtils messenger key.
      scaffoldMessengerKey: AppUtils.messengerKey,
      // Set the theme mode to light.
      themeMode: ThemeMode.light,
      // Set the theme to an instance of the AppTheme.
      theme: AppTheme().appTheme(),
      // Disable the debug banner.
      debugShowCheckedModeBanner: false,
      // Set the router delegate to an instance of the AppRouter delegate.
      routerDelegate: appRouter.delegate(),
      // Set the route information parser to an instance of the AppRouter default route parser.
      routeInformationParser: appRouter.defaultRouteParser(),
    );
  }
}
