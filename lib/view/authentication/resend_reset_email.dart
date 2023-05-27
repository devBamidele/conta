import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../res/color.dart';
import '../../res/components/countdown_timer.dart';
import '../../res/style/component_style.dart';
import '../../utils/app_router/router.gr.dart';
import '../../utils/widget_functions.dart';

class ResendResetEmail extends StatefulWidget {
  const ResendResetEmail({
    Key? key,
    required this.email,
  }) : super(key: key);

  final String email;

  @override
  State<ResendResetEmail> createState() => _ResendResetEmailState();
}

class _ResendResetEmailState extends State<ResendResetEmail> {
  final _countdownTimerKey = GlobalKey<CountdownTimerState>();

  late String email;

  // Activates the resend button
  bool activateResend = false;
  int countDownDuration = 59;

  Color buttonColor = AppColors.dividerColor;
  Color tappedColor = AppColors.dividerColor;

  @override
  void initState() {
    super.initState();
    setMail();
  }

  navigateToLogin() => context.router.replaceAll(
        [const LoginScreenRoute()],
      );

  String shortenEmail(String email) {
    String start = email.substring(0, 3);
    String end = email.substring(email.indexOf('@') - 2);
    String middle = '****';
    return '$start$middle$end';
  }

  setMail() => email = shortenEmail(widget.email);

  onFinished() {
    setState(() {
      activateResend = true;
      buttonColor = AppColors.primaryColor;
      tappedColor = AppColors.selectedBackgroundColor;
    });
  }

  resendEmail() async {
    if (_countdownTimerKey.currentState != null) {
      _countdownTimerKey.currentState!.restartTimer();
    }

    setState(() {
      activateResend = false;
      buttonColor = AppColors.dividerColor;
      tappedColor = AppColors.dividerColor;
    });

    // Re-send email verification to new user
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: widget.email)
        .then(
          (value) => log('Sent verification email'),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: pagePadding,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  addHeight(70),
                  const Text(
                    'Update password',
                    style: TextStyle(
                      height: 1.1,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  addHeight(10),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'A password reset link has been sent to $email',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.opaqueTextColor,
                      ),
                    ),
                  ),
                  addHeight(60),
                  Visibility(
                    visible: !activateResend,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Resend code in',
                          style: TextStyle(height: 1.4, fontSize: 18),
                        ),
                        addWidth(3),
                        CountdownTimer(
                          key: _countdownTimerKey,
                          textStyle: const TextStyle(
                            height: 1.4,
                            fontSize: 18,
                            color: AppColors.primaryColor,
                          ),
                          durationInSeconds: countDownDuration,
                          onTimerTick: (duration) {
                            setState(() {});
                          },
                          onFinished: onFinished,
                        ),
                        addWidth(3),
                        const Text('s')
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    OutlinedButton(
                      style: resendButtonStyle(
                        foregroundColor: tappedColor,
                        sideColor: buttonColor,
                      ),
                      onPressed: () => activateResend ? resendEmail() : null,
                      child: Text(
                        'Resend',
                        style: TextStyle(
                          fontSize: 18,
                          color: buttonColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    addHeight(20),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [shadow],
                      ),
                      child: ElevatedButton(
                        style: elevatedButton,
                        onPressed: () => navigateToLogin(),
                        child: const Text(
                          'Proceed to Login',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
