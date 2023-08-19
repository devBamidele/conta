import 'package:conta/utils/app_router/router.gr.dart';
import 'package:conta/utils/services/contacts_service.dart';
import 'package:conta/utils/services/notification_service.dart';
import 'package:conta/view_model/auth_provider.dart';
import 'package:conta/view_model/chat_provider.dart';
import 'package:conta/view_model/photo_provider.dart';
import 'package:conta/view_model/search_provider.dart';
import 'package:conta/view_model/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'app/my_app.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await NotificationService().initNotifications();

  await ContactService().initContactService();

  getIt.registerSingleton<AppRouter>(AppRouter());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PhotoProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProxyProvider<UserProvider, ChatProvider>(
          create: (_) => ChatProvider(),
          update: (_, userData, chatProvider) {
            return chatProvider!..updateUserData(userData);
          },
        )
      ],
      child: const MyApp(),
    ),
  );
}
