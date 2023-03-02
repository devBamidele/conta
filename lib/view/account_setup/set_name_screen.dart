import 'package:auto_route/auto_route.dart';
import 'package:conta/res/style/component_style.dart';
import 'package:conta/view/account_setup/set_photo_page.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../res/color.dart';
import '../../res/components/custom_back_button.dart';
import '../../res/components/custom_text_field.dart';
import '../../res/components/shake_error.dart';
import '../../utils/app_utils.dart';
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

  final nameFocusNode = FocusNode();

  final formKey1 = GlobalKey<FormState>();

  final shakeState1 = GlobalKey<ShakeWidgetState>();

  Color nameColor = AppColors.hintTextColor;
  Color fillNameColor = AppColors.inputBackGround;

  bool _isNameEmpty = true;

  @override
  void initState() {
    super.initState();
    myNameController.addListener(_updateNameEmpty);

    nameFocusNode.addListener(_updateNameColor);
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

  @override
  void dispose() {
    myNameController.dispose();
    nameFocusNode.dispose();

    formKey1.currentState?.dispose();

    shakeState1.currentState?.dispose();

    super.dispose();
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    } else if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value)) {
      return 'Username can only contain letters, numbers, and spaces';
    } else if (value.trim().length < 4 || value.trim().length > 20) {
      return 'Username must be between 4 and 20 characters long';
    }
    return null;
  }

  void onContinuePressed() {
    if (formKey1.currentState!.validate()) {
      setValues();
    } else {
      shakeState1.currentState?.shake();
      AppUtils.vibrate;
    }
  }

  void setValues() {
    final name = myNameController.text.trim();
    Provider.of<AuthenticationProvider>(context, listen: false)
        .setUsername(name);

    context.router.pushNamed(SetPhotoScreen.tag);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
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
                      hintText: 'Name',
                      prefixIcon: Icon(
                        IconlyBold.profile,
                        color: nameColor,
                      ),
                      validation: validateUsername,
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
