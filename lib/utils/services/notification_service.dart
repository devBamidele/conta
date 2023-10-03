import 'dart:convert';
import 'dart:developer';

import 'package:conta/view_model/messages_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../main.dart';
import '../../models/response.dart';
import '../app_router/router.gr.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final icon = 'notification';
  final androidPriority = Priority.high;

  final _androidChannel = const AndroidNotificationChannel(
    'high importance channel',
    'High Importance Notifications',
    importance: Importance.max,
    description: 'This channel is ued for notifications from Chatbox',
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    await FirebaseMessaging.instance.requestPermission().then((value) =>
        log('Notification authorization status: ${value.authorizationStatus}'));

    initPushNotifications();
    initLocalNotifications();
  }

  Future<void> initPushNotifications() async {
    // The app was launched due to a notification
    FirebaseMessaging.instance.getInitialMessage().then(handleInitialMessage);

    // A notification is received while the app was already running
    FirebaseMessaging.onMessageOpenedApp.listen(handleForegroundMessage);

    // Executes the high level function when the app is not in foreground
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    FirebaseMessaging.onMessage.listen((event) {
      final notification = event.notification;

      if (notification == null) return;

      final response = Response.fromJson(event.data);

      bool same = MessagesProvider.same(response) ?? false;

      if (same) {
        return;
      }

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            importance: _androidChannel.importance,
            priority: androidPriority,
            channelDescription: _androidChannel.description,
            icon: icon,
            // groupKey:
          ),
        ),

        // Pass information from push to local
        payload: jsonEncode(event.toMap()),
      );
    });
  }

  Future<void> initLocalNotifications() async {
    final android = AndroidInitializationSettings(icon);
    final settings = InitializationSettings(android: android);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await platform?.createNotificationChannel(_androidChannel);
  }
}

@pragma('vm:entry-point')
Future<void> onDidReceiveNotificationResponse(
  NotificationResponse response,
) async {
  if (response.payload == null) return;

  final message = RemoteMessage.fromMap(jsonDecode(response.payload!));

  handleForegroundMessage(message);
}

void handleForegroundMessage(RemoteMessage? message) {
  if (message == null) return;

  final response = Response.fromJson(message.data);

  getIt<AppRouter>().push(IntermediaryRoute(data: response));
}

void handleInitialMessage(RemoteMessage? message) {
  if (message == null) return;

  final response = Response.fromJson(message.data);

  getIt<AppRouter>()
      .pushAll([const HomeScreenRoute(), IntermediaryRoute(data: response)]);
}

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  debugPrint('Background message detected');
}
