import 'package:conta/utils/app_router/router.dart';
import 'package:conta/utils/app_router/router.gr.dart';
import 'package:conta/utils/extensions.dart';
import 'package:conta/utils/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:provider/provider.dart';

import '../../../../../res/color.dart';
import '../../../../../res/components/custom/custom_back_button.dart';
import '../../../../../res/components/custom/custom_text_field.dart';
import '../../../../../res/components/shake_error.dart';
import '../../../../../res/style/app_text_style.dart';
import '../../../../../res/style/component_style.dart';
import '../../../../../utils/app_utils.dart';
import '../../../../../utils/widget_functions.dart';
import '../../../../../view_model/user_provider.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({
    super.key,
    required this.oldPassword,
  });

  final String oldPassword;

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  late UserProvider userProvider;

  bool _showUpdateButton = false;

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();

  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  final newPassFocusNode = FocusNode();
  final confirmPassFocusNode = FocusNode();

  final shakeState1 = GlobalKey<ShakeWidgetState>();
  final shakeState2 = GlobalKey<ShakeWidgetState>();

  Color password1Color = AppColors.hintTextColor;
  Color password2Color = AppColors.hintTextColor;

  Color fillPassword1Color = Colors.white;
  Color fillPassword2Color = Colors.white;

  late bool _pass1Visible;
  late bool _pass2Visible;

  bool _isPass1Empty = true;
  bool _isPass2Empty = true;

  void _updatePassword2Color() {
    setState(() {
      password1Color = newPassFocusNode.hasFocus
          ? AppColors.selectedFieldColor
          : _isPass1Empty
              ? AppColors.hintTextColor
              : AppColors.blackColor;
      fillPassword1Color = newPassFocusNode.hasFocus
          ? AppColors.selectedBackgroundColor
          : Colors.white;
    });
  }

  void _updatePassword3Color() {
    setState(() {
      password2Color = confirmPassFocusNode.hasFocus
          ? AppColors.selectedFieldColor
          : _isPass2Empty
              ? AppColors.hintTextColor
              : AppColors.blackColor;
      fillPassword2Color = confirmPassFocusNode.hasFocus
          ? AppColors.selectedBackgroundColor
          : Colors.white;
    });
  }

  void toggle2Visibility() {
    setState(() {
      _pass1Visible = !_pass1Visible;
    });
  }

  void toggle3Visibility() {
    setState(() {
      _pass2Visible = !_pass2Visible;
    });
  }

  void _updatePassword2Empty() {
    setState(() {
      _isPass1Empty = newPassController.text.isEmpty;
    });
  }

  void _updatePassword3Empty() {
    setState(() {
      _isPass2Empty = confirmPassController.text.isEmpty;
    });
  }

  @override
  void initState() {
    super.initState();

    _pass1Visible = true;
    _pass2Visible = true;

    newPassController.addListener(_updatePassword2Empty);
    confirmPassController.addListener(_updatePassword3Empty);

    newPassController.addListener(showUpdateButton);
    confirmPassController.addListener(showUpdateButton);

    newPassFocusNode.addListener(_updatePassword2Color);
    confirmPassFocusNode.addListener(_updatePassword3Color);

    userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  showUpdateButton() {
    setState(() {
      _showUpdateButton = newPassController.text == confirmPassController.text;
    });
  }

  @override
  void dispose() {
    super.dispose();

    newPassController.dispose();
    confirmPassController.dispose();

    newPassFocusNode.dispose();
    confirmPassFocusNode.dispose();
  }

  onUpdatePressed() {
    final pass1 = formKey1.currentState?.validate();
    final pass2 = formKey2.currentState?.validate();

    if (!pass1! && !pass2!) {
      shakeState1.currentState?.shake();
      shakeState2.currentState?.shake();
    } else if (!pass1) {
      shakeState1.currentState?.shake();
    } else if (!pass2!) {
      shakeState2.currentState?.shake();
    } else {
      updatePassword();
      return;
    }
    Vibrate.feedback(FeedbackType.success);
  }

  Future<void> updatePassword() async {
    final newPassword = newPassController.text;
    final oldPassword = widget.oldPassword;

    await userProvider.updatePassword(
      context: context,
      newPassword: newPassword,
      oldPassword: oldPassword,
      showSnackbar: showSnackbar,
      onUpdate: onUpdate,
    );
  }

  void onUpdate() {
    AuthService().signOutFromApp();

    navReplaceAll(context, [const LoginScreenRoute()]);
  }

  void showSnackbar(String message) {
    if (mounted) {
      AppUtils.showSnackbar(message);
    }
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
                return Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomBackButton(
                              padding: EdgeInsets.only(top: 20),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Update Password',
                                style: AppTextStyles.headlineLarge
                                    .copyWith(fontSize: 32),
                              ),
                              addHeight(4),
                              Text(
                                "You'll be required to resign in",
                                style: AppTextStyles.headlineSmall,
                              )
                            ],
                          ),
                        ),
                        addHeight(16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "New Password",
                              style: AppTextStyles.passwordText,
                            ),
                            addHeight(8),
                            Form(
                              key: formKey1,
                              child: ShakeWidget(
                                key: shakeState1,
                                child: CustomTextField(
                                  focusNode: newPassFocusNode,
                                  textController: newPassController,
                                  customFillColor: fillPassword1Color,
                                  hintText: 'Password',
                                  obscureText: _pass1Visible,
                                  validation: (value) =>
                                      value.validatePassword(),
                                  suffixIcon: IconButton(
                                    icon: visibilityIcon(
                                        _pass1Visible, password1Color),
                                    onPressed: toggle2Visibility,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        addHeight(12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Confirm Password",
                              style: AppTextStyles.passwordText,
                            ),
                            addHeight(8),
                            Form(
                              key: formKey2,
                              child: ShakeWidget(
                                key: shakeState2,
                                child: CustomTextField(
                                  focusNode: confirmPassFocusNode,
                                  textController: confirmPassController,
                                  customFillColor: fillPassword2Color,
                                  hintText: 'Password',
                                  obscureText: _pass2Visible,
                                  validation: (value) =>
                                      value.validatePassword(),
                                  onFieldSubmitted: (password) =>
                                      onUpdatePressed(),
                                  suffixIcon: IconButton(
                                    icon: visibilityIcon(
                                        _pass2Visible, password2Color),
                                    onPressed: toggle3Visibility,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (_showUpdateButton)
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
                            onPressed: onUpdatePressed,
                            child: const Text(
                              'Update',
                              style: AppTextStyles.labelMedium,
                            ),
                          ),
                        ),
                      )
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
