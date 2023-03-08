import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:conta/utils/app_router/router.gr.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../res/color.dart';
import '../../res/components/custom_back_button.dart';
import '../../res/style/component_style.dart';
import '../../utils/app_utils.dart';
import '../../utils/widget_functions.dart';
import '../../view_model/authentication_provider.dart';

class SetPhotoScreen extends StatefulWidget {
  const SetPhotoScreen({Key? key}) : super(key: key);

  static const tag = '/set_photo_screen';

  @override
  State<SetPhotoScreen> createState() => _SetPhotoScreenState();
}

class _SetPhotoScreenState extends State<SetPhotoScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _picker = ImagePicker();
  File? _imageFile;

  Future<void> createUser() async {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    final username = authProvider.username!;
    final email = authProvider.email!;
    final password = authProvider.password!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: AppColors.primaryShadeColor,
          size: 60,
        ),
      ),
    );

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = userCredential.user!.uid;

      // Upload the image and create the User in firestore
      authProvider.uploadImageWithData(userId, _imageFile);

      // Update the display name
      await userCredential.user!.updateDisplayName(username);

      // Send email verification to new user
      await userCredential.user!.sendEmailVerification();

      verifyAccount(userCredential);
    } catch (e) {
      // Handle exceptions
      if (e.toString() == 'An error occurred while uploading the image') {
        AppUtils.showSnackbar(e.toString());
      } else {
        AppUtils.showSnackbar('An error occurred while creating the account. '
            'Please try again later.');
      }
    } finally {
      context.router.pop();
    }
  }

  verifyAccount(UserCredential credential) => context.router.replaceAll(
        [VerifyAccountScreenRoute(userCredential: credential)],
      );

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
    return Consumer<AuthenticationProvider>(
      builder: (_, authProvider, Widget? child) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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
                            'Add a photo to boost profile engagement',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.25,
                              color: AppColors.opaqueTextColor,
                            ),
                          ),
                        ),
                        addHeight(55),
                        GestureDetector(
                          onTap: () => _pickImage(ImageSource.camera),
                          child: CircleAvatar(
                            radius: 90,
                            backgroundColor: photoContainerDecoration.color,
                            backgroundImage: _imageFile != null
                                ? FileImage(_imageFile!)
                                : null,
                            child: _imageFile == null
                                ? const Icon(
                                    IconlyBold.profile,
                                    color: Color(0xFF9E9E9E),
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
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
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
      },
    );
  }
}
