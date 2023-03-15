import 'dart:developer';

import 'package:conta/view_model/authentication_provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:conta/view_model/chat_messages_provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  OneSignal.shared.setAppId('2abe9a4d-e1f6-4532-b940-ade3289c7227');

  // We recommend removing the following code and instead using an
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
