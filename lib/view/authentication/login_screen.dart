import 'package:auto_route/auto_route.dart';
import 'package:conta/res/components/custom_back_button.dart';
import 'package:conta/res/components/custom_check_box.dart';
import 'package:conta/res/components/login_options.dart';
import 'package:conta/res/style/component_style.dart';
import 'package:conta/utils/app_router/router.gr.dart';
import 'package:conta/view/authentication/forgot_password_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:iconly/iconly.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../res/color.dart';
import '../../res/components/custom_text_field.dart';
import '../../res/components/shake_error.dart';
import '../../utils/app_utils.dart';
import '../../utils/services/auth_service.dart';
import '../../utils/services/messaging_service.dart';
import '../../utils/widget_functions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const tag = '/login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthService _authService = AuthService();
  late final MessagingService _messagingService = MessagingService();

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

  useFirstLogin() {
    myEmailController.text = 'bamideledavid.ajewole@gmail.com';
    myPasswordController.text = 'Bamidele1234';
  }

  useSecondLogin() {
    myEmailController.text = 'bamideledavid.femi@gmail.com';
    myPasswordController.text = 'Olorunfemi004';
  }

  useThirdLogin() {
    myEmailController.text = 'ajewole.bamidele@stu.cu.edu.ng';
    myPasswordController.text = 'dele004';
  }

  void onContinuePressed() {
    useSecondLogin();

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
      login();
      return;
    }
    Vibrate.feedback(FeedbackType.heavy);
  }

  Future<void> login() async {
    final String email = myEmailController.text.trim();
    final String password = myPasswordController.text;

    showDialog(
      context: context,
      builder: (context) => Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: AppColors.primaryShadeColor,
          size: 60,
        ),
      ),
    );

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      // User is authenticated and email is verified
      if (user != null && user.emailVerified) {
        // Set One Signal id for the User
        _messagingService.setExternalUserId(user.uid);
        // Tell Firebase the user is now online
        _authService.updateUserOnlineStatus(true);
        navigateToHome();
      } else {
        // Email is not verified
        AppUtils.showSnackbar('Please verify your email before logging in');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        // User's device is not connected to the internet,
        AppUtils.showSnackbar('No internet connection');
      } else {
        // Handle login errors
        AppUtils.showSnackbar('Invalid email or password');
      }
    } catch (e) {
      // Handle other errors
      AppUtils.showSnackbar(
          'An error occurred while checking email and password. Please try again later.');
    } finally {
      context.router.pop();
    }
  }

  navigateToHome() => context.router.replaceAll([const PersistentTabRoute()]);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        AppUtils.showSnackbar(
            'Screen Width: $screenWidth\nScreen Height: $screenHeight');
      },
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
                  'Login to your Account',
                  style: TextStyle(
                    height: 1.1,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                addHeight(10),
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    'Enter your email and password below',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.25,
                      color: AppColors.opaqueTextColor,
                    ),
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
                      validation: (email) =>
                          email != null && !EmailValidator.validate(email)
                              ? 'Enter a valid email '
                              : null,
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
                        obscureText:
                            _passwordVisible, //This will obscure text dynamically
                        validation: (value) => value != null && value.length < 6
                            ? 'Enter a minimum of 6 characters'
                            : null,
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
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
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
                    onPressed: onContinuePressed,
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                addHeight(28),
                GestureDetector(
                  onTap: () =>
                      context.router.pushNamed(ForgotPasswordScreen.tag),
                  child: const Text(
                    'Forgot the password?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      letterSpacing: 0.2,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                addHeight(40),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const Divider(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      color: Colors.white,
                      child: const Text(
                        'or continue with',
                        style: TextStyle(
                          fontSize: 18,
                          height: 1.4,
                          letterSpacing: 0.2,
                          color: AppColors.continueWithColor,
                        ),
                      ),
                    ),
                  ],
                ),
                addHeight(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LoginOptions(
                      scale: 0.9,
                      onTap: () {},
                      path: 'assets/images/google.svg',
                    ),
                    LoginOptions(
                      scale: 0.6,
                      onTap: () {},
                      path: 'assets/images/facebook.svg',
                    ),
                    LoginOptions(
                      scale: 0.9,
                      onTap: () {},
                      path: 'assets/images/github.svg',
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
