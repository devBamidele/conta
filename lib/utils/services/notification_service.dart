import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final _tokenController = StreamController<String?>.broadcast();

  Stream<String?> get tokenStream => _tokenController.stream;

  Future<void> getToken() async {
    String? token = await _messaging.getToken();
    log('The token is $token');
    _tokenController.add(token);

    _messaging.onTokenRefresh.listen((fcmToken) {
      // Note: This callback is fired at each app startup and whenever a new
      // token is generated.
      _tokenController.add(fcmToken);
    }).onError((err) {
      // Error getting token.
    });
  }

  void dispose() {
    _tokenController.close();
  }

  getMessagesInForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilst in the foreground!');
      log('Message data: ${message.data}');

      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
      }
    });
  }

  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      // Navigate to the chat screen here
    }
  }

  void sendNotification(String? tokenId, String sender, String message) async {
    // Create a message payload
    Map<String, String>? payload = {
      'title': sender,
      'body': message,
    };

    log('The token id of the person who will receive the message is $tokenId');
    // Send the message payload to the other user's device
    await FirebaseMessaging.instance.sendMessage(
      // Set the FCM registration token of the other user's device
      to: tokenId,
      data: payload,
      collapseKey: '',
      messageId: '',
      messageType: '',
      ttl: 10,
    );
  }

  //data: payload.toJson()
}
