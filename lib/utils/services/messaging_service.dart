import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

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



  void setExternalUserId(String id) {
    OneSignal.shared.setExternalUserId(id);
  }

  void receiveForegroundNotification() {
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      event.complete(event.notification);
    });
  }

  void openNotification() {
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // Will be called whenever a notification is opened/button pressed.
    });
  }

  void permissionObserver() {
    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // Will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
    });
  }

  void subscriptionObserver() {
    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      // Will be called whenever the subscription changes
      // (ie. user gets registered with OneSignal and gets a user ID)
    });
  }

  void emailSubscriptionObserver() {
    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges emailChanges) {
      // Will be called whenever then user's email subscription changes
      // (ie. OneSignal.setEmail(email) is called and the user gets registered
    });
  }


  void dispose() {
    _tokenController.close();
  }
}
