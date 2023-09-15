import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../res/color.dart';
import '../../res/components/countdown_timer.dart';
import '../../res/components/custom/custom_back_button.dart';
import '../../res/style/app_text_style.dart';
import '../../res/style/component_style.dart';
import '../../utils/app_router/router.dart';
import '../../utils/app_router/router.gr.dart';
import '../../utils/widget_functions.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({
    Key? key,
    required this.email,
    this.pop = false,
  }) : super(key: key);

  final String email;
  final bool pop;

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final _countdownTimerKey = GlobalKey<CountdownTimerState>();

  late String email;
  late bool pop;

  // Activates the resend button
  bool activateResend = false;
  int countDownDuration = 59;

  Color buttonColor = AppColors.dividerColor;
  Color tappedColor = AppColors.dividerColor;

  @override
  void initState() {
    super.initState();

    pop = widget.pop;

    setMail();
  }

  navigateToLogin() => navReplaceAll(
        context,
        [const LoginScreenRoute()],
      );

  setMail() => email = widget.email;

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
      backgroundColor: pop ? null : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: pagePadding,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (pop)
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomBackButton(
                          padding: EdgeInsets.only(top: 20),
                        ),
                      ],
                    ),
                  addHeight(pop ? 16 : 70),
                  const Text(
                    'Update password',
                    style: AppTextStyles.headlineLarge,
                  ),
                  addHeight(10),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'A password reset link has been sent to ${widget.email}',
                      textAlign: TextAlign.left,
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: pop ? AppColors.blackShade : null,
                      ),
                    ),
                  ),
                  addHeight(40),
                  Visibility(
                    visible: !activateResend,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Resend code in',
                          style: AppTextStyles.titleSmall,
                        ),
                        addWidth(3),
                        CountdownTimer(
                          key: _countdownTimerKey,
                          textStyle: AppTextStyles.titleSmall.copyWith(
                            color: AppColors.primaryColor,
                          ),
                          durationInSeconds: countDownDuration,
                          onTimerTick: (duration) {
                            setState(() {});
                          },
                          onFinished: onFinished,
                        ),
                        addWidth(3),
                        const Text('s', style: AppTextStyles.titleSmall)
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    if (activateResend)
                      Visibility(
                        visible: pop,
                        replacement: OutlinedButton(
                          style: resendButtonStyle(
                            foregroundColor: tappedColor,
                            sideColor: buttonColor,
                          ),
                          onPressed: () => resendEmail(),
                          child: Text(
                            'Resend',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: buttonColor,
                            ),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [shadow],
                          ),
                          child: ElevatedButton(
                            style: elevatedButton,
                            onPressed: () => resendEmail(),
                            child: const Text(
                              'Resend',
                              style: AppTextStyles.labelMedium,
                            ),
                          ),
                        ),
                      ),
                    if (!pop)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          addHeight(20),
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [shadow],
                            ),
                            child: ElevatedButton(
                              style: elevatedButton,
                              onPressed: navigateToLogin,
                              child: const Text(
                                'Proceed to Login',
                                style: AppTextStyles.labelMedium,
                              ),
                            ),
                          ),
                        ],
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
