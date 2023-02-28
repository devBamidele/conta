import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../res/color.dart';
import '../../res/components/custom_back_button.dart';
import '../../res/style/component_style.dart';
import '../../utils/widget_functions.dart';
import '../../view_model/authentication_provider.dart';

class SetPhotoScreen extends StatefulWidget {
  const SetPhotoScreen({Key? key}) : super(key: key);

  static const tag = '/set_photo_screen';

  @override
  State<SetPhotoScreen> createState() => _SetPhotoScreenState();
}

class _SetPhotoScreenState extends State<SetPhotoScreen> {
  final _picker = ImagePicker();
  File? _imageFile;

  void onSkipPressed() {}

  // Select image from gallery
  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await _picker.pickImage(source: source);
    setState(() {
      _imageFile = pickedImage != null ? File(pickedImage.path) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final authProvider = context.watch<AuthenticationProvider>();
    // print(authProvider.username.toString());
    return Consumer<AuthenticationProvider>(
      builder: (context, authProvider, _) {
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
                                onTap: onSkipPressed,
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
                          onTap: () => _pickImage(ImageSource.gallery),
                          child: CircleAvatar(
                            radius: 80,
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
                        const Text(
                          'Bamidele Ajewole',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 50,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [shadow],
                        ),
                        child: ElevatedButton(
                          style: elevatedButton,
                          onPressed: () => _pickImage(ImageSource.gallery),
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
