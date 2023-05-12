import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HeartbeatService with WidgetsBindingObserver {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Make the constructor private to prevent creating instances from outside
  HeartbeatService._privateConstructor();

  // Create a static instance variable to hold the single instance of the service
  static final HeartbeatService _instance =
      HeartbeatService._privateConstructor();

  // Create a factory constructor to return the single instance of the service
  factory HeartbeatService() => _instance;

  Timer? _heartbeatTimer;

  /// Start the heartbeat service.
  void start() {
    WidgetsBinding.instance.addObserver(this);
    _startHeartbeatTimer();
  }

  /// Stop the heartbeat service.
  void stop() {
    WidgetsBinding.instance.removeObserver(this);
    _stopHeartbeatTimer();
  }

  void _startHeartbeatTimer() {
    _heartbeatTimer = Timer.periodic(const Duration(minutes: 3), (timer) async => 
      await sendHeartbeat()
    );
  }

  void _stopHeartbeatTimer() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  /// Sends a heartbeat signal to Firestore.
  ///
  /// This method sends a heartbeat signal to Firestore to let the server know
  /// that the user is still online. It checks if the user is authenticated and
  /// if there is an internet connection before sending the signal.
  Future<void> sendHeartbeat() async {
    User? user = _auth.currentUser;
    if (user == null) {
      return;
    }

    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return; // No internet connection, exit early
    }

    final docRef = _firestore.doc('users/${user.uid}');
    try {
      await docRef.update({
        'lastSeen': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Handle any exceptions that might occur
      log('Error sending heartbeat: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _startHeartbeatTimer();
        break;
      case AppLifecycleState.paused:
        _stopHeartbeatTimer();
        break;
      default:
        break;
    }
  }
}
