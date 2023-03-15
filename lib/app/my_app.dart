import 'package:conta/view_model/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../res/app_theme.dart';
import '../utils/app_router/router.gr.dart';
import '../utils/app_utils.dart';
import '../utils/services/auth_service.dart';
import '../utils/services/messaging_service.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late final AuthService _authService = AuthService();
  late final MessagingService _messagingService = MessagingService();

  @override
  void initState() {
    super.initState();
    // Get the unique token for the device
    _messagingService.getToken();

    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    // Listen for token updates
    _messagingService.tokenStream
        .listen((token) => authProvider.deviceToken = token);

    // Register this object as a observer of the WidgetsBinding instance
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    // Close the Stream Controller
    _messagingService.dispose();
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
