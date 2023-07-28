import 'dart:async';

import 'package:conta/res/style/component_style.dart';
import 'package:conta/utils/app_router/router.dart';
import 'package:conta/utils/app_router/router.gr.dart';
import 'package:conta/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../res/color.dart';
import '../../res/components/custom/custom_back_button.dart';
import '../../res/components/custom_text_field.dart';
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

  final myNameController = TextEditingController();
  final myUserNameController = TextEditingController();
  String? existingUserName;

  final nameFocusNode = FocusNode();
  final usernameFocusNode = FocusNode();

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();

  final shakeState1 = GlobalKey<ShakeWidgetState>();
  final shakeState2 = GlobalKey<ShakeWidgetState>();

  Color nameColor = AppColors.hintTextColor;
  Color fillNameColor = AppColors.inputBackGround;

  Color usernameColor = AppColors.hintTextColor;
  Color fillUserNameColor = AppColors.inputBackGround;

  bool _isNameEmpty = true;
  bool _isUserNameEmpty = true;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    authProvider = Provider.of<AuthProvider>(context, listen: false);

    myNameController.addListener(_updateNameEmpty);

    nameFocusNode.addListener(_updateNameColor);

    myUserNameController.addListener(_updateUserNameEmpty);

    myUserNameController.addListener(_onSearchChanged);

    usernameFocusNode.addListener(_updateUserNameColor);
  }

  void _updateNameEmpty() {
    setState(() {
      _isNameEmpty = myNameController.text.isEmpty;
    });
  }

  void _updateNameColor() {
    setState(() {
      nameColor = nameFocusNode.hasFocus
          ? AppColors.selectedFieldColor
          : _isNameEmpty
              ? AppColors.hintTextColor
              : Colors.black87;
      fillNameColor = nameFocusNode.hasFocus
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
              : Colors.black87;
      fillUserNameColor = usernameFocusNode.hasFocus
          ? AppColors.selectedBackgroundColor
          : AppColors.inputBackGround;
    });
  }

  _onSearchChanged() {
    final text = myUserNameController.text;
    if (text.validateInput()) {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(
        const Duration(milliseconds: 500),
        () async {
          // Perform the username availability check here
          bool unique = await authProvider.checkIfUsernameExists(text);
          setState(() {
            existingUserName =
                unique ? null : 'This username is already occupied';
          });
        },
      );
    }
  }

  @override
  void dispose() {
    myNameController.dispose();
    nameFocusNode.dispose();

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
    final name = formKey1.currentState?.validate();
    final username = formKey2.currentState?.validate();

    if (!name! && !username!) {
      shakeState1.currentState?.shake();
      shakeState2.currentState?.shake();
    } else if (!name) {
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
    final name = myNameController.text.trim();
    final userName = myUserNameController.text.trim();

    authProvider.setNameAndUserName(name, userName);

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
                  'What\'s your name?',
                  style: AppTextStyles.headlineLarge,
                ),
                addHeight(10),
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    'This will be displayed on your profile',
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
                      focusNode: nameFocusNode,
                      textController: myNameController,
                      customFillColor: fillNameColor,
                      hintText: 'Full Name',
                      prefixIcon: Icon(
                        IconlyBold.profile,
                        color: nameColor,
                      ),
                      validation: (name) => name.validateName(),
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
                        focusNode: usernameFocusNode,
                        textController: myUserNameController,
                        customFillColor: fillUserNameColor,
                        hintText: 'User Name',
                        prefixIcon: Icon(
                          Icons.alternate_email_rounded,
                          color: usernameColor,
                        ),
                        validation: (username) =>
                            username.validateUsername(existingUserName),
                      ),
                    ),
                  ),
                ),
                addHeight(40),
                Container(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
