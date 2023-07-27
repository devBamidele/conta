import 'package:conta/utils/services/storage_manager.dart';
import 'package:conta/view_model/auth_provider.dart';
import 'package:conta/view_model/chat_messages_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await dotenv.load();

  // Activate app check
  // await FirebaseAppCheck.instance
  //   .activate(androidProvider: AndroidProvider.debug);

  // Get the application document directory
  await StorageManager.initialize();

  /*
  OneSignal.shared.setAppId(dotenv.env['APP_ID']!);

  OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.none);
  // In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    log("Accepted permission: $accepted");
  });

   */
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatMessagesProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
