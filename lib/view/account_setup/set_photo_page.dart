import 'dart:io';

import 'package:conta/utils/app_router/router.gr.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../res/color.dart';
import '../../res/components/custom/custom_back_button.dart';
import '../../res/style/app_text_style.dart';
import '../../res/style/component_style.dart';
import '../../utils/app_router/router.dart';
import '../../utils/app_utils.dart';
import '../../utils/widget_functions.dart';
import '../../view_model/auth_provider.dart';

class SetPhotoScreen extends StatefulWidget {
  const SetPhotoScreen({Key? key}) : super(key: key);

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
      ).then((value) => onScreenPop());

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
      if (_imageFile != null) {
        authProvider.profilePic = _imageFile;
      }
    });
  } //

  Future<bool> onScreenPop() async {
    authProvider.clearCachedPic();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: onScreenPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: pagePadding,
              child: Consumer<AuthProvider>(
                builder: (_, data, __) {
                  return Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const CustomBackButton(
                            padding: EdgeInsets.only(left: 0, top: 25),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  SizedBox(
                                    height: 170,
                                    width: 170,
                                    child: FileProfilePic(
                                      imageFile: data.profilePic,
                                    ),
                                  ),
                                  UploadPhotoWidget(
                                    onTap: () =>
                                        _pickImage(ImageSource.gallery),
                                  )
                                ],
                              ),
                            ],
                          ),
                          addHeight(36),
                          Text(
                            data.username ?? 'No name set',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 30,
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
                              data.profilePic == null ? 'Skip' : 'Continue',
                              style: AppTextStyles.labelMedium,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UploadPhotoWidget extends StatelessWidget {
  const UploadPhotoWidget({
    super.key,
    required this.onTap,
    this.bottom = 3,
    this.right = 3,
  });

  final Function() onTap;
  final double? bottom;
  final double? right;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      right: right,
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.hintTextColor,
              ),
              child: const Icon(
                IconlyBold.camera,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FileProfilePic extends StatelessWidget {
  final File? imageFile;

  const FileProfilePic({
    Key? key,
    this.imageFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageFile == null) {
      // If imageFile is null, return the noProfilePic widget
      return CircleAvatar(
        backgroundColor: AppColors.photoContainerColor,
        child: noProfilePic(size: 48),
      );
    } else {
      // If imageFile is not null, display the profile picture
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: FileImage(imageFile!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }
}
