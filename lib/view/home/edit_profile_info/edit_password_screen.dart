import 'package:conta/res/style/component_style.dart';
import 'package:conta/utils/extensions.dart';
import 'package:conta/view_model/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../res/color.dart';
import '../../../res/components/custom/custom_back_button.dart';
import '../../../res/components/custom/custom_text_field.dart';
import '../../../res/components/shake_error.dart';
import '../../../utils/widget_functions.dart';

class EditPasswordScreen extends StatefulWidget {
  const EditPasswordScreen({super.key});

  @override
  State<EditPasswordScreen> createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  bool _showSave = false;

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();

  final pass1Controller = TextEditingController();
  final pass2Controller = TextEditingController();
  final pass3Controller = TextEditingController();

  final pass1FocusNode = FocusNode();
  final pass2FocusNode = FocusNode();
  final pass3FocusNode = FocusNode();

  final shakeState1 = GlobalKey<ShakeWidgetState>();
  final shakeState2 = GlobalKey<ShakeWidgetState>();
  final shakeState3 = GlobalKey<ShakeWidgetState>();

  Color password1Color = AppColors.hintTextColor;
  Color password2Color = AppColors.hintTextColor;
  Color password3Color = AppColors.hintTextColor;

  Color fillPassword1Color = Colors.white;
  Color fillPassword2Color = Colors.white;
  Color fillPassword3Color = Colors.white;

  late bool _pass1Visible;
  late bool _pass2Visible;
  late bool _pass3Visible;

  bool _isPass1Empty = true;
  bool _isPass2Empty = true;
  bool _isPass3Empty = true;

  void updatePassword(UserProvider data) {}

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

  void _updatePassword2Color() {
    setState(() {
      password2Color = pass2FocusNode.hasFocus
          ? AppColors.selectedFieldColor
          : _isPass2Empty
              ? AppColors.hintTextColor
              : AppColors.blackColor;
      fillPassword2Color = pass2FocusNode.hasFocus
          ? AppColors.selectedBackgroundColor
          : Colors.white;
    });
  }

  void _updatePassword3Color() {
    setState(() {
      password3Color = pass3FocusNode.hasFocus
          ? AppColors.selectedFieldColor
          : _isPass3Empty
              ? AppColors.hintTextColor
              : AppColors.blackColor;
      fillPassword3Color = pass3FocusNode.hasFocus
          ? AppColors.selectedBackgroundColor
          : Colors.white;
    });
  }

  void toggle1Visibility() {
    setState(
      () => _pass1Visible = !_pass1Visible,
    );
  }

  void toggle2Visibility() {
    setState(() {
      _pass2Visible = !_pass2Visible;
    });
  }

  void toggle3Visibility() {
    setState(() {
      _pass3Visible = !_pass3Visible;
    });
  }

  void _updatePassword1Empty() {
    setState(() {
      _isPass1Empty = pass1Controller.text.isEmpty;
    });
  }

  void _updatePassword2Empty() {
    setState(() {
      _isPass2Empty = pass2Controller.text.isEmpty;
    });
  }

  void _updatePassword3Empty() {
    setState(() {
      _isPass3Empty = pass3Controller.text.isEmpty;
    });
  }

  void onContinuePressed() {}

  @override
  void initState() {
    super.initState();

    _pass1Visible = true;
    _pass2Visible = true;
    _pass3Visible = true;

    pass1Controller.addListener(_updatePassword1Empty);
    pass2Controller.addListener(_updatePassword2Empty);
    pass3Controller.addListener(_updatePassword3Empty);

    pass1FocusNode.addListener(_updatePassword1Color);
    pass2FocusNode.addListener(_updatePassword2Color);
    pass3FocusNode.addListener(_updatePassword3Color);
  }

  @override
  void dispose() {
    super.dispose();

    pass1Controller.dispose();
    pass2Controller.dispose();
    pass3Controller.dispose();

    pass1FocusNode.dispose();
    pass2FocusNode.dispose();
    pass3FocusNode.dispose();
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
            child: Consumer<UserProvider>(
              builder: (_, data, __) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomBackButton(
                          padding: EdgeInsets.only(top: 20),
                          icon: Icons.clear_rounded,
                        ), //
                        Visibility(
                          visible: _showSave == false,
                          child: CustomBackButton(
                            align: Alignment.centerRight,
                            padding: const EdgeInsets.only(top: 20),
                            icon: Icons.check_rounded,
                            action: () {
                              // Un-focus from the text field
                              FocusScope.of(context).unfocus();

                              updatePassword(data);
                            },
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blackColor,
                        ),
                      ),
                    ),
                    addHeight(8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Old Password",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.blackColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Forgot Password ?",
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.primaryShadeColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
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
                              suffixIcon: IconButton(
                                icon: visibilityIcon(
                                    _pass1Visible, password1Color),
                                onPressed: toggle1Visibility,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        addHeight(20),
                        const Text(
                          "New Password",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        addHeight(8),
                        Form(
                          key: formKey2,
                          child: ShakeWidget(
                            key: shakeState2,
                            child: CustomTextField(
                              focusNode: pass2FocusNode,
                              textController: pass2Controller,
                              customFillColor: fillPassword2Color,
                              hintText: 'Password',
                              obscureText: _pass2Visible,
                              validation: (value) => value.validatePassword(),
                              onFieldSubmitted: (password) =>
                                  onContinuePressed(),
                              suffixIcon: IconButton(
                                icon: visibilityIcon(
                                    _pass2Visible, password2Color),
                                onPressed: toggle2Visibility,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        addHeight(20),
                        const Text(
                          "Confirm Password",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        addHeight(8),
                        Form(
                          key: formKey3,
                          child: ShakeWidget(
                            key: shakeState3,
                            child: CustomTextField(
                              focusNode: pass3FocusNode,
                              textController: pass3Controller,
                              customFillColor: fillPassword3Color,
                              hintText: 'Password',
                              obscureText: _pass3Visible,
                              validation: (value) => value.validatePassword(),
                              onFieldSubmitted: (password) =>
                                  onContinuePressed(),
                              suffixIcon: IconButton(
                                icon: visibilityIcon(
                                    _pass3Visible, password3Color),
                                onPressed: toggle3Visibility,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
