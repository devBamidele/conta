import 'package:conta/res/style/component_style.dart';
import 'package:conta/utils/extensions.dart';
import 'package:conta/view_model/auth_provider.dart';
import 'package:conta/view_model/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:provider/provider.dart';

import '../../../../../res/color.dart';
import '../../../../../res/components/custom/custom_back_button.dart';
import '../../../../../res/components/custom/custom_text_field.dart';
import '../../../../../res/components/shake_error.dart';
import '../../../../../res/style/app_text_style.dart';
import '../../../../../utils/app_router/router.dart';
import '../../../../../utils/app_router/router.gr.dart';
import '../../../../../utils/app_utils.dart';
import '../../../../../utils/widget_functions.dart';

class VerifyPassword extends StatefulWidget {
  const VerifyPassword({super.key});

  @override
  State<VerifyPassword> createState() => _VerifyPasswordState();
}

class _VerifyPasswordState extends State<VerifyPassword> {
  late UserProvider userProvider;
  late AuthProvider authProvider;

  final formKey1 = GlobalKey<FormState>();
  final shakeState1 = GlobalKey<ShakeWidgetState>();

  final pass1Controller = TextEditingController();
  final pass1FocusNode = FocusNode();

  Color password1Color = AppColors.hintTextColor;
  Color fillPassword1Color = Colors.white;

  late bool _pass1Visible;
  bool _isPass1Empty = true;

  void _updatePassword1Color() {
    setState(() {
      password1Color = pass1FocusNode.hasFocus
          ? AppColors.selectedFieldColor
          : _isPass1Empty
              ? AppColors.hintTextColor
              : AppColors.blackColor;
      fillPassword1Color = pass1FocusNode.hasFocus
          ? AppColors.selectedBackgroundColor
          : Colors.white;
    });
  }

  void toggleVisibility() {
    setState(
      () => _pass1Visible = !_pass1Visible,
    );
  }

  void _updatePassword1Empty() {
    setState(() {
      _isPass1Empty = pass1Controller.text.isEmpty;
    });
  }

  void onContinuePressed() {
    final password = formKey1.currentState?.validate();

    if (!password!) {
      shakeState1.currentState?.shake();
    } else {
      verifyPassword();
      return;
    }

    Vibrate.feedback(FeedbackType.success);
  }

  void showSnackbar(String message) {
    if (mounted) {
      AppUtils.showSnackbar(message);
    }
  }

  Future<void> verifyPassword() async {
    final password = pass1Controller.text;

    await userProvider.verifyPassword(
      context: context,
      password: password,
      showSnackbar: showSnackbar,
      onVerify: onVerify,
    );
  }

  void onVerify() {
    final oldPassword = pass1Controller.text;

    navPush(context, UpdatePasswordRoute(oldPassword: oldPassword));
  }

  // We stopped here
  void forgotPasswordTap() {
    final email = FirebaseAuth.instance.currentUser!.email!;

    authProvider.sendPasswordResetEmail(
      context: context,
      email: email,
      showSnackbar: showSnackbar,
      onAuthenticate: onEmailSent,
    );
  }

  void onEmailSent(String email) {
    navPush(
      context,
      UpdatePasswordScreenRoute(email: email, pop: true),
    );
  }

  @override
  void initState() {
    super.initState();

    _pass1Visible = true;

    pass1Controller.addListener(_updatePassword1Empty);

    pass1FocusNode.addListener(_updatePassword1Color);

    userProvider = Provider.of<UserProvider>(context, listen: false);

    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();

    pass1Controller.dispose();

    pass1FocusNode.dispose();

    formKey1.currentState?.dispose();

    shakeState1.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: pagePadding,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomBackButton(
                          padding: EdgeInsets.only(top: 20),
                          icon: Icons.clear_rounded,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Verify Password',
                            style: AppTextStyles.headlineLarge
                                .copyWith(fontSize: 32),
                          ),
                          addHeight(4),
                          const Text(
                            "Just making sure it's you",
                            style: AppTextStyles.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                    addHeight(16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Current password",
                          style: AppTextStyles.passwordText,
                        ),
                        addHeight(8),
                        Form(
                          key: formKey1,
                          child: ShakeWidget(
                            key: shakeState1,
                            child: CustomTextField(
                              focusNode: pass1FocusNode,
                              textController: pass1Controller,
                              customFillColor: fillPassword1Color,
                              hintText: 'Password',
                              obscureText: _pass1Visible,
                              validation: (value) => value.validatePassword(),
                              onFieldSubmitted: (password) =>
                                  onContinuePressed(),
                              prefixIcon: lockIcon(password1Color),
                              suffixIcon: IconButton(
                                icon: visibilityIcon(
                                    _pass1Visible, password1Color),
                                onPressed: toggleVisibility,
                              ),
                            ),
                          ),
                        ),
                        addHeight(8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: forgotPasswordTap,
                              child: Text(
                                'Forgot password ?',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.labelSmall.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Container(
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
