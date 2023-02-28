import 'package:flutter/material.dart';

class AuthenticationProvider extends ChangeNotifier {
  /// Holds the username
  String? username;

  setUsername(String? newName) {
    username = newName;
    notifyListeners();
  }
}
