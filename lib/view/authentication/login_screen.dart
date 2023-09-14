import 'dart:async';

import 'package:conta/res/components/custom/custom_back_button.dart';
import 'package:conta/res/style/app_text_style.dart';
import 'package:conta/res/style/component_style.dart';
import 'package:conta/utils/app_router/router.gr.dart';
import 'package:conta/utils/extensions.dart';
import 'package:conta/view_model/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:provider/provider.dart';

import '../../res/color.dart';
import '../../res/components/custom/custom_text_field.dart';
import '../../res/components/shake_error.dart';
import '../../utils/app_router/router.dart';
import '../../utils/app_utils.dart';
import '../../utils/services/auth_service.dart';
import '../../utils/widget_functions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthService _authService = AuthService();
  late AuthProvider authProvider;

  final myEmailController = TextEditingController();
  final myPasswordController = TextEditingController();

  final passwordFocusNode = FocusNode();
  final emailFocusNode = FocusNode();

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();

  final shakeState1 = GlobalKey<ShakeWidgetState>();
  final shakeState2 = GlobalKey<ShakeWidgetState>();

  Color passwordColor = AppColors.hintTextColor;
  Color fillPasswordColor = AppColors.inputBackGround;

  Color emailColor = AppColors.hintTextColor;
  Color fillEmailColor = AppColors.inputBackGround;

  late bool _passwordVisible;
  late bool isRootScreen;

  bool _isPasswordEmpty = true;
  bool _isEmailEmpty = true;

  @override
  void initState() {
    super.initState();

    isRootScreen = isRoot(context);

    _passwordVisible = true;

    myPasswordController.addListener(_updatePasswordEmpty);

    passwordFocusNode.addListener(_updatePasswordColor);

    myEmailController.addListener(_updateEmailEmpty);

    emailFocusNode.addListener(_updateEmailColor);

    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  void _updatePasswordEmpty() {
    setState(() {
      _isPasswordEmpty = myPasswordController.text.isEmpty;
    });
  }

  void _updateEmailEmpty() {
    setState(() {
      _isEmailEmpty = myEmailController.text.isEmpty;
    });
  }

  void _updatePasswordColor() {
    setState(() {
      passwordColor = passwordFocusNode.hasFocus
          ? AppColors.selectedFieldColor
          : _isPasswordEmpty
              ? AppColors.hintTextColor
              : Colors.black87;
      fillPasswordColor = passwordFocusNode.hasFocus
          ? AppColors.selectedBackgroundColor
          : AppColors.inputBackGround;
    });
  }

  void _updateEmailColor() {
    setState(() {
      emailColor = emailFocusNode.hasFocus
          ? AppColors.selectedFieldColor
          : _isEmailEmpty
              ? AppColors.hintTextColor
              : Colors.black87;
      fillEmailColor = emailFocusNode.hasFocus
          ? AppColors.selectedBackgroundColor
          : AppColors.inputBackGround;
    });
  }

  @override
  void dispose() {
    myEmailController.dispose();
    myPasswordController.dispose();

    passwordFocusNode.dispose();
    emailFocusNode.dispose();

    formKey1.currentState?.dispose();
    formKey2.currentState?.dispose();

    shakeState1.currentState?.dispose();
    shakeState2.currentState?.dispose();

    super.dispose();
  }

  void showSnackbar(String message) {
    if (mounted) {
      AppUtils.showSnackbar(message);
    }
  }

  void onContinuePressed() {
    // AppLogins.useFourthLogin(myEmailController, myPasswordController);

    final email = formKey1.currentState?.validate();
    final password = formKey2.currentState?.validate();

    if (!email! && !password!) {
      shakeState1.currentState?.shake();
      shakeState2.currentState?.shake();
    } else if (!email) {
      shakeState1.currentState?.shake();
    } else if (!password!) {
      shakeState2.currentState?.shake();
    } else {
      loginWithEmailAndPassword();
      return;
    }
    Vibrate.feedback(FeedbackType.success);
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    await authProvider.loginWithGoogle(
      context: context,
      showSnackbar: showSnackbar,
      onAuthenticate: onAuthenticate,
    );
  }

  Future<void> loginWithEmailAndPassword() async {
    final email = myEmailController.text.trim();
    final password = myPasswordController.text;

    await authProvider.loginWithEmailAndPassword(
      email: email,
      context: context,
      password: password,
      showSnackbar: showSnackbar,
      onAuthenticate: onAuthenticate,
      showEmailSnackbar: showEmailSnackbar,
    );
  }

  // Function to show the "Email not verified" Snackbar
  void showEmailSnackbar(UserCredential credential) {
    if (mounted) {
      final user = credential.user!;

      AppUtils.showSnackbar(
        'Email not verified',
        label: 'VERIFY',
        delay: const Duration(seconds: 5),
        onLabelTapped: () {
          user.sendEmailVerification();
          onVerifyTapped(credential);
        },
      );
    }
  }

  void onVerifyTapped(UserCredential credential) => navReplaceAll(
        context,
        [VerifyAccountScreenRoute(userCredential: credential)],
      );

  void onAuthenticate() {
    gotoHome();
    _authService.updateUserOnlineStatus(true);
  }

  void toggleVisibility() {
    setState(
      () => _passwordVisible = !_passwordVisible,
    );
  }

  gotoHome() => navReplaceAll(context, [const HomeScreenRoute()]);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: pagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Visibility(
                    visible: isRootScreen,
                    replacement: const CustomBackButton(
                      padding: EdgeInsets.only(left: 0, top: 25),
                    ),
                    child: addHeight(50),
                  ),
                  addHeight(20),
                  const Text(
                    'Login to your Account',
                    style: AppTextStyles.headlineLarge,
                  ),
                  addHeight(10),
                  Container(
                    alignment: Alignment.topLeft,
                    child: const Text(
                      'Enter your email and password below',
                      textAlign: TextAlign.left,
                      style: AppTextStyles.headlineSmall,
                    ),
                  ),
                  addHeight(55),
                  Form(
                    key: formKey1,
                    child: ShakeWidget(
                      key: shakeState1,
                      child: CustomTextField(
                        focusNode: emailFocusNode,
                        textController: myEmailController,
                        customFillColor: fillEmailColor,
                        hintText: 'Email',
                        prefixIcon: emailIcon(emailColor),
                        validation: (email) => email?.trim().validateEmail(),
                      ),
                    ),
                  ),
                  Form(
                    key: formKey2,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                        bottom: 10,
                      ),
                      child: ShakeWidget(
                        key: shakeState2,
                        child: CustomTextField(
                          focusNode: passwordFocusNode,
                          textController: myPasswordController,
                          customFillColor: fillPasswordColor,
                          action: TextInputAction.done,
                          hintText: 'Password',
                          obscureText: _passwordVisible,
                          validation: (value) => value.validatePassword(),
                          prefixIcon: lockIcon(passwordColor),
                          onFieldSubmitted: (password) => onContinuePressed(),
                          suffixIcon: IconButton(
                            icon:
                                visibilityIcon(_passwordVisible, passwordColor),
                            onPressed: toggleVisibility,
                          ),
                        ),
                      ), //
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () => navPush(
                            context, const RecoverPasswordScreenRoute()),
                        child: Text(
                          'Forgot password ?',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.labelSmall.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  addHeight(40),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [shadow],
                    ),
                    child: ElevatedButton(
                      style: elevatedButton,
                      onPressed: onContinuePressed,
                      child: const Text(
                        'Continue',
                        style: AppTextStyles.labelMedium,
                      ),
                    ),
                  ),
                  addHeight(28),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Don\'t have an account? ',
                          style: AppTextStyles.headlineSmall,
                        ),
                        TextSpan(
                          text: ' Sign up',
                          style: AppTextStyles.labelSmall.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                          recognizer: TapGestureRecognizer()
                            // handle click event for the Signup link
                            ..onTap = () =>
                                navReplace(context, const SignUpScreenRoute()),
                        ),
                      ],
                    ),
                  ),
                  addHeight(40),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(
                          color: Colors.grey[200],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.white,
                        child: const Text(
                          'or continue with',
                          style: AppTextStyles.titleSmall,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Center(
                      child: LoginOptions(
                        onTap: () => loginWithGoogle(context),
                        path: 'assets/images/google.svg',
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginOptions extends StatelessWidget {
  const LoginOptions({
    Key? key,
    required this.onTap,
    required this.path,
    this.scale = 1,
  }) : super(key: key);

  final VoidCallback onTap;
  final String path;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: loginOptionsStyle,
      child: Transform.scale(
        scale: scale,
        child: SvgPicture.asset(path),
      ),
    );
  }
}
