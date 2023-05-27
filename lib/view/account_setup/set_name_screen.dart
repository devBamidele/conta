import 'package:auto_route/auto_route.dart';
import 'package:conta/res/style/component_style.dart';
import 'package:conta/view/account_setup/set_photo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../res/color.dart';
import '../../res/components/custom_back_button.dart';
import '../../res/components/custom_text_field.dart';
import '../../res/components/shake_error.dart';
import '../../utils/widget_functions.dart';
import '../../view_model/authentication_provider.dart';

class SetNameScreen extends StatefulWidget {
  const SetNameScreen({
    Key? key,
  }) : super(key: key);

  static const tag = '/set_name_screen';

  @override
  State<SetNameScreen> createState() => _SetNameScreenState();
}

class _SetNameScreenState extends State<SetNameScreen> {
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

  @override
  void initState() {
    super.initState();
    myNameController.addListener(_updateNameEmpty);

    nameFocusNode.addListener(_updateNameColor);

    myUserNameController.addListener(_updateUserNameEmpty);

    myUserNameController.addListener(_checkIfUsernameExits);

    usernameFocusNode.addListener(_updateUserNameColor);
  }

  void _checkIfUsernameExits() async {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    // check if the username already exists in the Firestore database
    final exists =
        await authProvider.checkIfUsernameExists(myUserNameController.text);

    if (exists) {
      setState(() {
        existingUserName = 'This username is already occupied';
      });
    } else {
      setState(() {
        existingUserName = null;
      });
    }
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

    super.dispose();
  }

  String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    } else if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value)) {
      return 'Only letters, numbers, underscores, and spaces are allowed.';
    } else if (value.trim().length < 4 || value.trim().length > 25) {
      return 'Username must be between 4 and 20 characters long';
    } else {
      return null;
    }
  }

  String? username(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    } else if (!RegExp(r'^[a-zA-Z0-9_\s]+$').hasMatch(value)) {
      return 'Only letters, numbers, underscores, and spaces are allowed.';
    } else if (value.trim().length < 4 || value.trim().length > 20) {
      return 'Username must be between 4 and 20 characters long';
    } else {
      return existingUserName;
    }
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
    Vibrate.feedback(FeedbackType.heavy);
  }

  // Save the values to the authentication provider and proceed
  void setValues() {
    final name = myNameController.text.trim();
    final userName = myUserNameController.text.trim();
    Provider.of<AuthenticationProvider>(context, listen: false)
        .setNameAndUserName(name, userName);

    context.router.pushNamed(SetPhotoScreen.tag);
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
                const CustomBackButton(
                  padding: EdgeInsets.only(left: 0, top: 25),
                ),
                addHeight(20),
                const Text(
                  'What\'s your name?',
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
                    'This will be displayed on your profile',
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
                      focusNode: nameFocusNode,
                      textController: myNameController,
                      customFillColor: fillNameColor,
                      hintText: 'Full Name',
                      prefixIcon: Icon(
                        IconlyBold.profile,
                        color: nameColor,
                      ),
                      validation: name,
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
                        validation: username,
                      ),
                    ),
                  ),
                ),
                addHeight(67),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
