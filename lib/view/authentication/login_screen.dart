import 'package:conta/res/components/custom_check_box.dart';
import 'package:conta/res/style/component_style.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconly/iconly.dart';

import '../../res/color.dart';
import '../../res/components/custom_text_field.dart';
import '../../utils/widget_functions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const tag = '/login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final myEmailController = TextEditingController();
  final myPasswordController = TextEditingController();

  final passwordFocusNode = FocusNode();
  final emailFocusNode = FocusNode();

  final formKey = GlobalKey<FormState>();

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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                addHeight(80),
                const Text(
                  'Login to your Account',
                  style: TextStyle(
                    height: 1.1,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                addHeight(14),
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
                addHeight(62),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomTextField(
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
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                        ),
                        child: CustomTextField(
                          focusNode: passwordFocusNode,
                          textController: myPasswordController,
                          customFillColor: fillPasswordColor,
                          action: TextInputAction.done,
                          hintText: 'Password',
                          obscureText:
                              _passwordVisible, //This will obscure text dynamically
                          validation: (value) =>
                              value != null && value.length < 6
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
                      )
                    ],
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
                    onPressed: () {},
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
                const Text(
                  'Forgot the password?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    letterSpacing: 0.2,
                    color: AppColors.primaryColor,
                  ),
                ),
                addHeight(40),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Divider(
                      // color: AppColors.hintTextColor.withOpacity(0.5),
                      thickness: 1,
                    ),
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
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppColors.hintTextColor.withOpacity(0.5),
                        ),
                        minimumSize: const Size(90, 60),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                      ),
                      onPressed: () {},
                      child: SvgPicture.asset(
                        'assets/images/g.svg',
                      ),
                    )
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
