import 'dart:async';
import 'dart:developer';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';

class MessagingService {
  // Get your environment variables
  final apiKey = dotenv.env['ONESIGNAL_API_KEY'];
  final appId = dotenv.env['APP_ID'];
  final cloudFunctionUrl = dotenv.env['CLOUD_FUNCTION_URL'];

  Future<String> generateHash(String input) async {
    // Parse the Url of the Google Cloud Function
    final functionUrl = Uri.parse(cloudFunctionUrl!);

    final response = await http.post(
      functionUrl,
      body: json.encode({
        'input': input,
        'key': apiKey,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    return json.decode(response.body)['hash'];
  }

  Future<void> setExternalUserId(String id) async {
    final authHashToken = await generateHash(id);
    OneSignal.shared.setExternalUserId(id, authHashToken);
  }

  Future<void> sendNotification({
    required List<String> recipientIds,
    required String message,
    required String senderName,
  }) async {
    final url = Uri.parse('https://onesignal.com/api/v1/notifications');
    final headers = {
      'Authorization': 'Basic $apiKey',
      'accept': 'application/json',
      'content-type': 'application/json',
    };
    final body = jsonEncode({
      "app_id": appId,
      'include_external_user_ids': recipientIds,
      "channel_for_external_user_ids": "push",
      "isAndroid": true,
      'contents': {
        'en': message,
      },
      'buttons': [
        {
          "id": "id1",
          "text": "Reply",
          "icon": "ic_reply",
        },
        {
          "id": "id2",
          "text": "Mark as read",
          "icon": "ic_menu_send",
        }
      ],
      'android_group_message': '',
      'headings': {
        'en': senderName,
      },
      'data': {
        'message': message,
      },
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        log('Notification sent successfully.');
      } else {
        log(response.body);
        log('Notification sending failed: ${response.statusCode}');
      }
    } catch (e) {
      log('Error sending notification: $e');
    }
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
}
