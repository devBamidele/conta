import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conta/models/new_user_data.dart';
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _picker = ImagePicker();
  File? _imageFile;

  void proceed() async {
    final data = Provider.of<AuthenticationProvider>(context, listen: false)
        .getUserData();
    createUser(data);
  }

  navigateToHome() => context.router.replaceAll(
        [const PersistentTabRoute()],
      );

  Future<void> createUser(UserData data) async {
    final name = data.username;
    final email = data.email;
    final password = data.password;

    loading(email);

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store additional user data to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
      });

      // Send email verification to new user
      await userCredential.user!.sendEmailVerification();

      //navigateToHome();
    } catch (e) {
      // Handle exceptions
      AppUtils.showSnackbar(
          'An error occurred while creating the account. Please try again later.');
    }
  }

  String shortenEmail(String email) {
    String start = email.substring(0, 3);
    String end = email.substring(email.indexOf('@') - 1);
    String middle = '';
    for (int i = 0; i < email.indexOf('@') - 4; i++) {
      middle += '*';
    }
    return '$start$middle$end';
  }

  /// Display the loading dialog
  loading(String email) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Verify your Email',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            height: 1.2,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryShadeColor,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              ''
              'A link has been sent to ${shortenEmail(email)}'
              'You will be redirected to the Login page in a few seconds..',
              style: const TextStyle(
                fontSize: 16,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            addHeight(32),
            LoadingAnimationWidget.staggeredDotsWave(
              color: AppColors.primaryShadeColor,
              size: 60,
            ),
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
    );
  }

  void buttonPressed() {
    if (_imageFile == null) {
      _pickImage(ImageSource.gallery);
    } else {
      proceed();
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
                                onTap: proceed,
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
                          onPressed: () => buttonPressed(),
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
