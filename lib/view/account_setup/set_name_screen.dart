import 'dart:async';

import 'package:conta/res/style/component_style.dart';
import 'package:conta/utils/app_router/router.dart';
import 'package:conta/utils/app_router/router.gr.dart';
import 'package:conta/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:provider/provider.dart';

import '../../res/color.dart';
import '../../res/components/custom/custom_back_button.dart';
import '../../res/components/custom/custom_text_field.dart';
import '../../res/components/shake_error.dart';
import '../../res/style/app_text_style.dart';
import '../../utils/widget_functions.dart';
import '../../view_model/auth_provider.dart';

class SetNameScreen extends StatefulWidget {
  const SetNameScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SetNameScreen> createState() => _SetNameScreenState();
}

class _SetNameScreenState extends State<SetNameScreen> {
  late AuthProvider authProvider;

  String? existingUserName;
  String? existingPhoneNumber;

  final myPhoneController = TextEditingController();
  final myUserNameController = TextEditingController();

  final phoneFocusNode = FocusNode();
  final usernameFocusNode = FocusNode();

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();

  final shakeState1 = GlobalKey<ShakeWidgetState>();
  final shakeState2 = GlobalKey<ShakeWidgetState>();

  Color phoneColor = AppColors.hintTextColor;
  Color fillPhoneColor = AppColors.inputBackGround;

  Color usernameColor = AppColors.hintTextColor;
  Color fillUserNameColor = AppColors.inputBackGround;

  bool _isPhoneEmpty = true;
  bool _isUserNameEmpty = true;

  Timer? _debounce;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    authProvider = Provider.of<AuthProvider>(context, listen: false);

    myPhoneController.addListener(_updatePhoneEmpty);

    myPhoneController.addListener(_onPhoneNumberChanged);

    phoneFocusNode.addListener(_updatePhoneColor);

    myUserNameController.addListener(_updateUserNameEmpty);

    myUserNameController.addListener(_onUserNameChanged);

    usernameFocusNode.addListener(_updateUserNameColor);
  }

  void _updatePhoneEmpty() {
    setState(() {
      _isPhoneEmpty = myPhoneController.text.isEmpty;
    });
  }

  void _updatePhoneColor() {
    setState(() {
      phoneColor = phoneFocusNode.hasFocus
          ? AppColors.selectedFieldColor
          : _isPhoneEmpty
              ? AppColors.hintTextColor
              : AppColors.blackColor;
      fillPhoneColor = phoneFocusNode.hasFocus
          ? AppColors.selectedBackgroundColor
          : AppColors.inputBackGround;
    });
  }

  void _updateUserNameEmpty() {
    setState(() {
      _isUserNameEmpty = myUserNameController.text.isEmpty;
    });
  }

  void _updateUserNameColor() {
    setState(() {
      usernameColor = usernameFocusNode.hasFocus
          ? AppColors.selectedFieldColor
          : _isUserNameEmpty
              ? AppColors.hintTextColor
              : AppColors.blackColor;
      fillUserNameColor = usernameFocusNode.hasFocus
          ? AppColors.selectedBackgroundColor
          : AppColors.inputBackGround;
    });
  }

  _onPhoneNumberChanged() async {
    String text = myPhoneController.text.trim();

    if (text.validatePhoneNumberInput()) {
      setState(() {
        isLoading = true;
        existingPhoneNumber = 'Checking ...';
      });

      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(
        const Duration(milliseconds: 1000),
        () async {
          // Perform the phone number availability check here
          final result =
              await authProvider.isPhoneUnique(text.addCountryCode());

          final unique = result['isEmpty'] ?? false;
          final message =
              result['message'] ?? 'Already registered with another account';

          setState(() {
            existingPhoneNumber = unique ? null : message;
            isLoading = false;
          });
        },
      );
    }
  }

  _onUserNameChanged() async {
    final text = myUserNameController.text.trim();

    if (text.validateUserNameInput()) {
      setState(() {
        isLoading = true;
        existingUserName = 'Checking ...';
      });

      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(
        const Duration(milliseconds: 1000),
        () async {
          // Perform the username availability check here
          final result = await authProvider.isUsernameUnique(text);

          final unique = result['isEmpty'] ?? false;
          final message = result['message'] ?? 'Oops, that username is taken';

          setState(() {
            existingUserName = unique ? null : message;
            isLoading = false;
          });
        },
      );
    }
  }

  @override
  void dispose() {
    myPhoneController.dispose();
    phoneFocusNode.dispose();

    myUserNameController.dispose();
    usernameFocusNode.dispose();

    formKey1.currentState?.dispose();
    formKey2.currentState?.dispose();

    shakeState1.currentState?.dispose();
    shakeState2.currentState?.dispose();

    _debounce?.cancel();
    super.dispose();
  }

  void onContinuePressed() {
    final phone = formKey1.currentState?.validate();
    final username = formKey2.currentState?.validate();

    if (!phone! && !username!) {
      shakeState1.currentState?.shake();
      shakeState2.currentState?.shake();
    } else if (!phone) {
      shakeState1.currentState?.shake();
    } else if (!username!) {
      shakeState2.currentState?.shake();
    } else {
      setValues();
      return;
    }
    Vibrate.feedback(FeedbackType.success);
  }

  // Save the values to the authentication provider and proceed
  void setValues() {
    final phone = myPhoneController.text.trim().addCountryCode();
    final userName = myUserNameController.text.trim();

    authProvider.setPhoneAndUserName(username: userName, phone: phone);

    navPush(context, const SetPhotoScreenRoute());
  }

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
                  const CustomBackButton(
                    padding: EdgeInsets.only(left: 0, top: 25),
                  ),
                  addHeight(20),
                  const Text(
                    'Personal Information',
                    style: AppTextStyles.headlineLarge,
                  ),
                  addHeight(10),
                  Container(
                    alignment: Alignment.topLeft,
                    child: const Text(
                      'Let\'s get to know you better',
                      textAlign: TextAlign.left,
                      style: AppTextStyles.headlineSmall,
                    ),
                  ),
                  addHeight(55),
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
                          lengthLimit: 25,
                          focusNode: usernameFocusNode,
                          textController: myUserNameController,
                          customFillColor: fillUserNameColor,
                          hintText: 'User Name',
                          prefixIcon: Icon(
                            Icons.alternate_email_rounded,
                            color: usernameColor,
                            size: 22,
                          ),
                          validation: (username) =>
                              username.validateUsername(existingUserName),
                        ),
                      ),
                    ),
                  ),
                  Form(
                    key: formKey1,
                    child: ShakeWidget(
                      key: shakeState1,
                      shakeCount: 3,
                      shakeOffset: 6,
                      child: CustomTextField(
                        lengthLimit: 12,
                        focusNode: phoneFocusNode,
                        textController: myPhoneController,
                        customFillColor: fillPhoneColor,
                        hintText: 'Phone Number',
                        isPhone: true,
                        prefixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            phoneIcon(phoneColor),
                            addWidth(12),
                            const Text(
                              '+234',
                              style: TextStyle(
                                color: AppColors.blackColor,
                                letterSpacing: 1,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        validation: (name) => name
                            ?.trim()
                            .validatePhoneNumber(existingPhoneNumber),
                      ),
                    ),
                  ),
                  addHeight(10),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [shadow],
                      ),
                      child: ElevatedButton(
                        style: elevatedButton,
                        onPressed: onContinuePressed,
                        child: isLoading
                            ? displayLoading()
                            : const Text(
                                'Continue',
                                style: AppTextStyles.labelMedium,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
