import 'package:auto_route/auto_route.dart';
import 'package:conta/utils/app_router/router.dart';
import 'package:conta/utils/app_router/router.gr.dart';
import 'package:conta/utils/extensions.dart';
import 'package:conta/view_model/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_utils.dart';
import '../../../utils/widget_functions.dart';
import '../../color.dart';
import '../../style/app_text_style.dart';
import '../../style/component_style.dart';
import '../custom/custom_text_field.dart';
import '../shake_error.dart';

class DeleteAccountSheet extends StatefulWidget {
  const DeleteAccountSheet({super.key});

  @override
  State<DeleteAccountSheet> createState() => _DeleteAccountSheetState();
}

class _DeleteAccountSheetState extends State<DeleteAccountSheet> {
  late UserProvider userProvider;

  late bool _passwordVisible;
  bool _isPasswordEmpty = true;

  final passwordNode = FocusNode();
  final passController = TextEditingController();

  Color passwordColor = AppColors.hintTextColor;
  Color fillPasswordColor = AppColors.inputBackGround;

  final passwordShake = GlobalKey<ShakeWidgetState>();
  final formKey1 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _passwordVisible = true;

    passController.addListener(_updatePasswordEmpty);

    passwordNode.addListener(_updatePasswordColor);

    userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  void toggleVisibility() {
    setState(
      () => _passwordVisible = !_passwordVisible,
    );
  }

  void _updatePasswordEmpty() {
    setState(() {
      _isPasswordEmpty = passController.text.isEmpty;
    });
  }

  void _updatePasswordColor() {
    setState(() {
      passwordColor = passwordNode.hasFocus
          ? AppColors.selectedFieldColor
          : _isPasswordEmpty
              ? AppColors.hintTextColor
              : AppColors.blackColor;
      fillPasswordColor = passwordNode.hasFocus
          ? AppColors.selectedBackgroundColor
          : AppColors.inputBackGround;
    });
  }

  void showSnackbar(String message) {
    if (mounted) {
      AppUtils.showToast(message);
    }
  }

  void onContinuePressed() {
    final password = formKey1.currentState?.validate();

    if (!password!) {
      passwordShake.currentState?.shake();
    } else {
      deleteAccount();
      return;
    }

    Vibrate.feedback(FeedbackType.success);
  }

  Future<void> deleteAccount() async {
    final password = passController.text;

    await userProvider.deleteAccount(
      context: context,
      password: password,
      showSnackbar: showSnackbar,
      onDelete: onDelete,
    );
  }

  void onDelete() {
    navReplaceAll(
      context,
      [const LoginScreenRoute()],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Delete account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryShadeColor,
                    ),
                  ), //
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Divider(
                      color: Colors.grey[200],
                    ),
                  ),
                  const Text(
                    'Just making sure it\'s you',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Form(
                      key: formKey1,
                      child: ShakeWidget(
                        key: passwordShake,
                        child: CustomTextField(
                          action: TextInputAction.done,
                          focusNode: passwordNode,
                          textController: passController,
                          customFillColor: fillPasswordColor,
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
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: resendButtonStyle(),
                            onPressed: () => context.router.pop(),
                            child: Text(
                              'Cancel',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.primaryShadeColor,
                                fontSize: 16,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
                        addWidth(12),
                        Expanded(
                          child: ElevatedButton(
                            style: elevatedButton,
                            onPressed: () {
                              // Remove focus
                              FocusScope.of(context).unfocus();

                              // Perform callback
                              onContinuePressed();
                            },
                            child: Text(
                              'Yes, Delete',
                              style: AppTextStyles.labelMedium
                                  .copyWith(fontSize: 16, letterSpacing: 0.2),
                            ),
                          ),
                        ),
                      ],
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
