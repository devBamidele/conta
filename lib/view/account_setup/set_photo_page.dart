import 'dart:io';

import 'package:conta/res/color.dart';
import 'package:conta/utils/app_router/router.gr.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../res/components/custom/custom_back_button.dart';
import '../../res/style/app_text_style.dart';
import '../../res/style/component_style.dart';
import '../../utils/app_router/router.dart';
import '../../utils/app_utils.dart';
import '../../utils/widget_functions.dart';
import '../../view_model/auth_provider.dart';

class SetPhotoScreen extends StatefulWidget {
  const SetPhotoScreen({Key? key}) : super(key: key);

  static const tag = '/set_photo_screen';

  @override
  State<SetPhotoScreen> createState() => _SetPhotoScreenState();
}

class _SetPhotoScreenState extends State<SetPhotoScreen> {
  late AuthProvider authProvider;

  final _picker = ImagePicker();
  File? _imageFile;

  @override
  void initState() {
    super.initState();

    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  Future<void> createUser() async {
    authProvider.createUser(
      context: context,
      showSnackbar: showSnackbar,
      onAuthenticate: verifyAccount,
    );
  }

  verifyAccount(UserCredential credential) => navReplaceAll(
        context,
        [VerifyAccountScreenRoute(userCredential: credential)],
      );

  void showSnackbar(String message) {
    if (mounted) {
      AppUtils.showSnackbar(message);
    }
  }

  void addPhoto() {
    if (_imageFile == null) {
      _pickImage(ImageSource.gallery);
    } else {
      createUser();
    }
  }

  /// Select image from gallery
  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await _picker.pickImage(source: source);
    setState(() {
      _imageFile = pickedImage != null ? File(pickedImage.path) : null;
    });
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
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomBackButton(
                          padding: EdgeInsets.only(left: 0, top: 25),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: GestureDetector(
                            onTap: createUser,
                            child: const Text(
                              'Skip',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    addHeight(20),
                    const Text(
                      'Set a photo of yourself',
                      style: AppTextStyles.headlineLarge,
                    ),
                    addHeight(10),
                    Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'Add a photo to boost profile engagement',
                        textAlign: TextAlign.left,
                        style: AppTextStyles.headlineSmall,
                      ),
                    ),
                    addHeight(55),
                    GestureDetector(
                      onTap: () => _pickImage(ImageSource.camera),
                      child: CircleAvatar(
                        radius: 90,
                        backgroundColor: photoContainerDecoration.color,
                        backgroundImage:
                            _imageFile != null ? FileImage(_imageFile!) : null,
                        child: _imageFile == null
                            ? const Icon(
                                IconlyBold.profile,
                                color: AppColors.hintTextColor,
                                size: 58,
                              )
                            : null,
                      ),
                    ),
                    addHeight(36),
                    Text(
                      authProvider.username ?? 'No name set',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [shadow],
                    ),
                    child: ElevatedButton(
                      style: elevatedButton,
                      onPressed: () => addPhoto(),
                      child: Text(
                        _imageFile == null ? 'Add a photo' : 'Continue',
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
    );
  }
}
