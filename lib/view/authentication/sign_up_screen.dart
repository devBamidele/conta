import 'package:conta/res/color.dart';
import 'package:conta/utils/widget_functions.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  static const tag = '/sign_up_screen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final myEmailController = TextEditingController();
  final myPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
  }

  @override
  void dispose() {
    myEmailController.dispose();
    myPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                addHeight(80),
                const Text(
                  'Create your Account',
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
                    ),
                  ),
                ),
                addHeight(62),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: myEmailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? 'Enter a valid email'
                                : null,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          contentPadding: const EdgeInsets.all(18),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 22, right: 14),
                            child: Icon(
                              IconlyBold.message,
                              color: myEmailController.text.isEmpty
                                  ? AppColors.hintTextColor
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 12,
                          bottom: 19,
                        ),
                        child: TextFormField(
                          controller: myPasswordController,
                          textInputAction: TextInputAction.done,
                          obscureText:
                              _passwordVisible, //This will obscure text dynamically
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              value != null && value.length < 6
                                  ? 'Enter a minimum of 6 characters'
                                  : null,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            contentPadding: const EdgeInsets.all(18),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(left: 22, right: 14),
                              child: Icon(
                                IconlyBold.lock,
                                color: AppColors.hintTextColor,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _passwordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.hintTextColor,
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
                      )
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
