import 'package:conta/res/style/component_style.dart';
import 'package:conta/utils/widget_functions.dart';
import 'package:conta/view_model/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../res/color.dart';
import '../../res/components/countdown_timer.dart';
import '../../res/style/app_text_style.dart';
import '../../utils/app_router/router.dart';
import '../../utils/app_router/router.gr.dart';

class VerifyAccountScreen extends StatefulWidget {
  const VerifyAccountScreen({
    Key? key,
    required this.userCredential,
  }) : super(key: key);

  final UserCredential userCredential;

  @override
  State<VerifyAccountScreen> createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  final _countdownTimerKey = GlobalKey<CountdownTimerState>();

  late String email;
  late AuthProvider authProvider;

  // Activates the resend button
  bool activateResend = false;
  int countDownDuration = 59;

  Color buttonColor = AppColors.dividerColor;
  Color tappedColor = AppColors.dividerColor;

  navigateToLogin() => navReplaceAll(
        context,
        [const LoginScreenRoute()],
      );

  navigateToHome() => navReplaceAll(
        context,
        [const HomeScreenRoute()],
      );

  setMail() {
    email = widget.userCredential.user!.email!;
  }

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
    await widget.userCredential.user!.sendEmailVerification();
  }

  @override
  void initState() {
    super.initState();

    authProvider = Provider.of<AuthProvider>(context, listen: false);

    setMail();
  }

  Future<bool> onWillPop() async {
    authProvider.clearData();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
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
                      'Verify your email',
                      style: AppTextStyles.headlineLarge,
                    ),
                    addHeight(10),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'A link has been sent to $email',
                        textAlign: TextAlign.left,
                        style: AppTextStyles.headlineSmall,
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
                            style: AppTextStyles.titleSmall,
                          ),
                          addWidth(3),
                          CountdownTimer(
                            key: _countdownTimerKey,
                            textStyle: AppTextStyles.titleSmall.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            durationInSeconds: countDownDuration,
                            onTimerTick: (duration) => setState(() {}),
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
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      if (activateResend)
                        OutlinedButton(
                          style: resendButtonStyle(
                            foregroundColor: tappedColor,
                            sideColor: buttonColor,
                          ),
                          onPressed: resendEmail,
                          child: Text(
                            'Resend',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: buttonColor,
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
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
                            style: AppTextStyles.labelMedium,
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
      ),
    );
  }
}
