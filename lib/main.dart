import 'dart:developer';

import 'package:conta/view_model/authentication_provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:conta/view_model/chat_messages_provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await dotenv.load();

  // Activate app check
  await FirebaseAppCheck.instance
      .activate(androidProvider: AndroidProvider.debug);

  OneSignal.shared.setAppId(dotenv.env['APP_ID']!);

  OneSignal.shared.setLogLevel(OSLogLevel.debug, OSLogLevel.none);
  // In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    log("Accepted permission: $accepted");
  });

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
