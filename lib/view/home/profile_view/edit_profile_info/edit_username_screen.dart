import 'dart:async';

import 'package:conta/res/components/custom/custom_back_button.dart';
import 'package:conta/res/style/component_style.dart';
import 'package:conta/utils/extensions.dart';
import 'package:conta/view_model/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:provider/provider.dart';

import '../../../../res/color.dart';
import '../../../../res/components/custom/custom_text_field.dart';
import '../../../../res/components/shake_error.dart';
import '../../../../utils/app_utils.dart';
import '../../../../view_model/auth_provider.dart';

class EditUsernameScreen extends StatefulWidget {
  const EditUsernameScreen({super.key});

  @override
  State<EditUsernameScreen> createState() => _EditUsernameScreenState();
}

class _EditUsernameScreenState extends State<EditUsernameScreen> {
  late UserProvider userProvider;
  late AuthProvider authProvider;

  final nameNode = FocusNode();
  final nameController = TextEditingController();

  final fillColor = Colors.white;

  final formKey1 = GlobalKey<FormState>();
  final shakeState = GlobalKey<ShakeWidgetState>();

  bool _showSave = false;
  String _currentName = '';

  Timer? _debounce;
  String? existingUserName;

  @override
  void initState() {
    super.initState();

    userProvider = Provider.of<UserProvider>(context, listen: false);

    authProvider = Provider.of<AuthProvider>(context, listen: false);

    nameController.text = userProvider.userData?.username ?? '';

    _currentName = nameController.text;

    nameController.addListener(_onUsernameChanged);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();

    nameNode.dispose();

    formKey1.currentState?.dispose();
    shakeState.currentState?.dispose();
  }

  void showSnackbar(String message) {
    if (mounted) {
      AppUtils.showSnackbar(message);
    }
  }

  void onCheckPressed(UserProvider data) {
    if (formKey1.currentState!.validate()) {
      updateUsername();
    } else {
      // Perform some actions
      shakeState.currentState?.shake();

      Vibrate.feedback(FeedbackType.success);

      _updateUsernameAvailability(null, false);
      return;
    }
  }

  updateUsername() async {
    final newName = nameController.text.trim();

    await userProvider.updateUsername(
      newName,
      context: context,
      showSnackbar: showSnackbar,
    );

    setState(() {
      _currentName = newName;
      _showSave = false;
    });
  }

  void _onUsernameChanged() {
    final newName = nameController.text.trim();

    if (newName == _currentName) {
      _updateUsernameAvailability(null, false);
      return;
    }

    if (!newName.validateUserNameInput()) {
      _updateUsernameAvailability(null, false);
      return;
    }

    _updateUsernameAvailability('Checking ... ', false);

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () async {
      // Perform the username availability check here
      final result = await authProvider.isUsernameUnique(newName);

      final unique = result['isEmpty'] ?? false;
      final message = result['message'] ?? 'Oops, that username is taken';

      _updateUsernameAvailability(unique ? null : message, unique);
    });
  }

  void _updateUsernameAvailability(String? message, bool isUnique) {
    setState(() {
      existingUserName = message;
      _showSave = isUnique;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                        ),
                        Visibility(
                          visible: _showSave,
                          child: CustomBackButton(
                            align: Alignment.centerRight,
                            padding: const EdgeInsets.only(top: 20),
                            icon: Icons.check_rounded,
                            action: () {
                              // Un-focus from the text field
                              FocusScope.of(context).unfocus();

                              onCheckPressed(data);
                            },
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Username',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blackColor,
                            ),
                          ),
                          Text(
                            "Add a personal touch to your profile.",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.blackColor,
                            ),
                          )
                        ],
                      ),
                    ),
                    Form(
                      key: formKey1,
                      child: ShakeWidget(
                        key: shakeState,
                        child: CustomTextField(
                          focusNode: nameNode,
                          textController: nameController,
                          customFillColor: fillColor,
                          lengthLimit: 20,
                          hintText: 'Edit Name',
                          focusedBorderColor: Colors.transparent,
                          validation: (username) =>
                              username.validateUsername(existingUserName),
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
