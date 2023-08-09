import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final _firebaseMessaging = FirebaseMessaging.instance;
  final icon = '@drawable/ic_launcher';
  final androidPriority = Priority.high;
  final androidChannelId = '';
  final androidChannelName = 'High Importance Notifications';
  late Map token;

  final _androidChannel = const AndroidNotificationChannel(
    'high importance channel',
    'High Importance Notifications',
    importance: Importance.max,
    description: 'This channel is ued for notifications from Chatbox',
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    initPushNotifications();
    initLocalNotifications();
  }

  Future<void> initPushNotifications() async {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then(handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleForegroundMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((event) {
      final notification = event.notification;

      if (notification == null) return;

      handleForegroundMessage(event);

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
  log('---------- This is a foreground message ----------');
  log('Title: ${message.notification?.title}');
  log('Body: ${message.notification?.body}');
  log('Payload: ${message.data}');

  // Add some navigation here
}

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  log('---------- This is a background message ----------');
  log('Title: ${message.notification?.title}');
  log('Body: ${message.notification?.body}');
  log('Payload: ${message.data}');
}
