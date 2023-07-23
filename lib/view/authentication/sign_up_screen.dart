import 'package:auto_route/auto_route.dart';
import 'package:conta/res/color.dart';
import 'package:conta/res/components/shake_error.dart';
import 'package:conta/res/style/component_style.dart';
import 'package:conta/utils/extensions.dart';
import 'package:conta/utils/widget_functions.dart';
import 'package:conta/view/account_setup/set_name_screen.dart';
import 'package:conta/view/authentication/login_screen.dart';
import 'package:conta/view_model/authentication_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../res/components/custom/custom_back_button.dart';
import '../../res/components/custom/custom_check_box.dart';
import '../../res/components/custom_text_field.dart';
import '../../res/style/app_text_style.dart';
import '../../utils/app_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  static const tag = '/sign_up_screen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late AuthenticationProvider authProvider;

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
  bool _isChecked = false;

  bool _isPasswordEmpty = true;
  bool _isEmailEmpty = true;

  @override
  void initState() {
    super.initState();
    _passwordVisible = true;

    myPasswordController.addListener(_updatePasswordEmpty);

    passwordFocusNode.addListener(_updatePasswordColor);

    myEmailController.addListener(_updateEmailEmpty);

    emailFocusNode.addListener(_updateEmailColor);

    authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
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

  void validate() {
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
      checkEmailAndPassword();
      return;
    }
    Vibrate.feedback(FeedbackType.heavy);
  }

  Future<void> checkEmailAndPassword() async {
    final String email = myEmailController.text.trim();
    final String password = myPasswordController.text;

    await authProvider.checkEmailAndPassword(
      context: context,
      email: email,
      password: password,
      showSnackbar: showSnackbar,
      onAuthenticate: gotoNext,
    );
  }

  gotoNext() => context.router.pushNamed(SetNameScreen.tag);

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
                  'Create your Account',
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
                Form(
                  key: formKey2,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      bottom: 20,
                    ),
                    child: ShakeWidget(
                      key: shakeState2,
                      shakeCount: 3,
                      shakeOffset: 6,
                      child: CustomTextField(
                        focusNode: passwordFocusNode,
                        textController: myPasswordController,
                        customFillColor: fillPasswordColor,
                        action: TextInputAction.done,
                        hintText: 'Password',
                        obscureText: _passwordVisible,
                        validation: (value) => value.validatePassword(),
                        prefixIcon: Icon(
                          IconlyBold.lock,
                          color: passwordColor,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: passwordColor,
                          ),
                          onPressed: () {
                            // Update the state i.e. toggle the state of passwordVisible variable
                            setState(
                              () => _passwordVisible = !_passwordVisible,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomCheckbox(
                        value: _isChecked,
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value ?? false;
                          });
                        },
                      ),
                      const Text(
                        'Remember me',
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [shadow],
                  ),
                  child: ElevatedButton(
                    style: elevatedButton,
                    onPressed: validate,
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
                    style: AppTextStyles.labelSmall,
                    children: [
                      const TextSpan(
                        text: 'Already have an account?',
                      ),
                      TextSpan(
                        text: ' Login',
                        style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          // handle click event for the Login link
                          ..onTap =
                              () => context.router.pushNamed(LoginScreen.tag),
                      ),
                    ],
                  ),
                ),
                addHeight(50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.opaqueTextColor,
                      ),
                      children: [
                        const TextSpan(
                          text: 'By tapping Continue, you agree to our ',
                        ),
                        TextSpan(
                          text: 'Terms',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // handle click event for the Terms link
                            },
                        ),
                        const TextSpan(
                          text: ' & ',
                        ),
                        TextSpan(
                          text: 'Privacy policy',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // handle click event for the Privacy policy link
                            },
                        ),
                      ],
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
