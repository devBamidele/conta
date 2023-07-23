import 'package:auto_route/auto_route.dart';
import 'package:conta/res/components/shake_error.dart';
import 'package:conta/utils/app_router/router.gr.dart';
import 'package:conta/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../res/color.dart';
import '../../res/components/custom/custom_back_button.dart';
import '../../res/components/custom_text_field.dart';
import '../../res/style/app_text_style.dart';
import '../../res/style/component_style.dart';
import '../../utils/app_utils.dart';
import '../../utils/widget_functions.dart';
import '../../view_model/authentication_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  static const tag = '/forgot_password_screen';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late AuthenticationProvider authProvider;

  final myEmailController = TextEditingController();
  final emailFocusNode = FocusNode();

  final formKey = GlobalKey<FormState>();
  final shakeState = GlobalKey<ShakeWidgetState>();

  Color emailColor = AppColors.hintTextColor;
  Color fillEmailColor = AppColors.inputBackGround;

  bool _isEmailEmpty = true;

  @override
  void initState() {
    super.initState();

    myEmailController.addListener(_updateEmailEmpty);

    emailFocusNode.addListener(_updateEmailColor);

    authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
  }

  void _updateEmailEmpty() {
    setState(() {
      _isEmailEmpty = myEmailController.text.isEmpty;
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
    emailFocusNode.dispose();

    formKey.currentState?.dispose();
    shakeState.currentState?.dispose();

    super.dispose();
  }

  void onContinuePressed() {
    if (formKey.currentState!.validate()) {
      sendPasswordResetEmail();
    } else {
      shakeState.currentState?.shake();
      Vibrate.feedback(FeedbackType.heavy);
      return;
    }
  }

  void showSnackbar(String message) {
    if (mounted) {
      AppUtils.showSnackbar(message);
    }
  }

  void navigateToLogin(String email) => context.router.replaceAll(
        [ResendResetEmailRoute(email: email)],
      );

  Future<void> sendPasswordResetEmail() async {
    String email = myEmailController.text.trim();

    authProvider.sendPasswordResetEmail(
      context: context,
      email: email,
      showSnackbar: showSnackbar,
      onAuthenticate: navigateToLogin,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const CustomBackButton(
                  padding: EdgeInsets.only(left: 0, top: 25),
                ),
                addHeight(20),
                const Text(
                  'Recover your password',
                  style: AppTextStyles.headlineLarge,
                ),
                addHeight(10),
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    'Enter your email address',
                    textAlign: TextAlign.left,
                    style: AppTextStyles.headlineSmall,
                  ),
                ),
                addHeight(55),
                Form(
                  key: formKey,
                  child: ShakeWidget(
                    key: shakeState,
                    shakeCount: 3,
                    shakeOffset: 6,
                    child: CustomTextField(
                      focusNode: emailFocusNode,
                      textController: myEmailController,
                      customFillColor: fillEmailColor,
                      hintText: 'Email',
                      prefixIcon: Icon(
                        IconlyBold.message,
                        color: emailColor,
                      ),
                      validation: (email) => email.validateEmail(),
                    ),
                  ),
                ),
                addHeight(67),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [shadow],
                  ),
                  child: ElevatedButton(
                    style: elevatedButton,
                    onPressed: onContinuePressed,
                    child: const Text(
                      'Send Recovery OTP',
                      style: AppTextStyles.labelMedium,
                    ),
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
