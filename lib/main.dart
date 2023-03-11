import 'package:conta/res/app_theme.dart';
import 'package:conta/utils/app_router/router.gr.dart';
import 'package:conta/utils/app_utils.dart';
import 'package:conta/utils/auth_service/auth_service.dart';
import 'package:conta/view_model/authentication_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conta/view_model/chat_messages_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatMessagesProvider()),
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

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
      case AppLifecycleState.paused:
        // The app is now in the background
        _authService.updateUserOnlineStatus(false);
        break;
      default:
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
