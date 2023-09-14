import 'package:conta/res/components/custom/custom_text_field.dart';
import 'package:conta/res/style/component_style.dart';
import 'package:conta/view_model/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../res/color.dart';
import '../../../../res/components/custom/custom_back_button.dart';
import '../../../../utils/app_utils.dart';

class EditBioScreen extends StatefulWidget {
  const EditBioScreen({super.key});

  @override
  State<EditBioScreen> createState() => _EditBioScreenState();
}

class _EditBioScreenState extends State<EditBioScreen> {
  late UserProvider userProvider;

  final bioNode = FocusNode();

  final bioController = TextEditingController();

  final fillColor = Colors.white;

  bool _showSave = false;
  String _currentBio = '';

  @override
  void initState() {
    super.initState();

    userProvider = Provider.of<UserProvider>(context, listen: false);

    bioController.text = userProvider.userData?.bio ?? '';

    _currentBio = bioController.text;

    bioController.addListener(_showSaveButton);
  }

  // Something needs to be done here
  void _showSaveButton() {
    setState(() {
      _showSave = bioController.text != _currentBio;
    });
  }

  void showSnackbar(String message) {
    if (mounted) {
      AppUtils.showSnackbar(message);
    }
  }

  void updateBio(UserProvider userProvider) async {
    final newBio = bioController.text.trim();

    await userProvider.updateBio(
      newBio,
      context: context,
      showSnackbar: showSnackbar,
    );

    setState(() {
      _currentBio = newBio;
      _showSave = false;
    });
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
                          visible: _showSave,
                          child: CustomBackButton(
                            align: Alignment.centerRight,
                            padding: const EdgeInsets.only(top: 20),
                            icon: Icons.check_rounded,
                            action: () {
                              // Un-focus from the text field
                              FocusScope.of(context).unfocus();

                              updateBio(data);
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
                            'Bio',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blackColor,
                            ),
                          ),
                          Text(
                            "Add a personal touch to your profile.",
                            style: TextStyle(
                                fontSize: 16, color: AppColors.blackColor),
                          )
                        ],
                      ),
                    ),
                    CustomTextField(
                      focusNode: bioNode,
                      textController: bioController,
                      customFillColor: fillColor,
                      maxLength: 70,
                      hintText: 'Edit bio',
                      focusedBorderColor: Colors.transparent,
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
