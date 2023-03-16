import 'package:flutter/material.dart';

import '../res/app_theme.dart';
import '../utils/app_router/router.gr.dart';
import '../utils/app_utils.dart';
import '../utils/services/auth_service.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    // Register this object as a observer of the WidgetsBinding instance
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    // Unregister this object as a observer of the WidgetsBinding instance
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        // The app is now in the foreground
        _authService.updateUserOnlineStatus(true);
        break;
      default:
        // Any other case
        _authService.updateUserOnlineStatus(false);
        break;
    }
  }

  // Get an instance of the App Router
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scaffoldMessengerKey: AppUtils.messengerKey,
      themeMode: ThemeMode.light,
      theme: AppTheme().appTheme(),
      debugShowCheckedModeBanner: false,
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
    );
  }
}
