import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../utils/app_router/router.dart';
import '../../utils/app_router/router.gr.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isAuth = false;

  @override
  void initState() {
    super.initState();
    checkCurrentUser();

    _controller = AnimationController(vsync: this);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });

    startTimer();
  }

  void startTimer() => Timer(const Duration(seconds: 3), navigateNext);

  Future<void> checkCurrentUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      isAuth = true;
    }
  }

  navigateNext() {
    if (isAuth) {
      // User is authenticated, navigate to the home screen
      navReplace(context, const HomeScreenRoute());
    } else {
      // User is not authenticated, navigate to the login screen
      navReplace(context, const LoginScreenRoute());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/anim/splash.json',
          controller: _controller,
          onLoaded: (composition) {
            // Configure the AnimationController with the duration of the
            // Lottie file and start the animation.
            _controller
              ..duration = composition.duration
              ..forward();
          },
        ),
      ),
    );
  }
}
