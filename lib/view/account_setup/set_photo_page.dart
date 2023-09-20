import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:conta/utils/app_router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../res/color.dart';
import '../../res/components/custom/custom_back_button.dart';
import '../../res/components/profile/file_profile_pic.dart';
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

  verifyAccount(credential) => navReplaceAll(
        context,
        [VerifyAccountScreenRoute(userCredential: credential)],
      ).then((value) => onScreenPop());

  void showSnackbar(String message) {
    if (mounted) {
      AppUtils.showSnackbar(message);
    }
  }

  /// Select image from gallery
  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
        authProvider.profilePic = _imageFile;
      });
    }
  }

  /// Clear cached profile picture and return `true`.
  Future<bool> onScreenPop() {
    authProvider.clearCachedPic();
    return Future.value(true);
  }

  /// Preview profile picture and return the result.
  Future<bool?> profilePicPreview(File imageFile) async {
    return await context.router.push<bool?>(
      FileImagePreviewRoute(
        imageFile: imageFile,
        fromSignUp: true,
      ),
    );
  }

  /// View profile picture and clear it if result is `true`.
  Future<void> viewPic() async {
    if (_imageFile != null) {
      final result = await profilePicPreview(_imageFile!);
      if (result == true) {
        clearImage();
      }
    } else {
      AppUtils.showSnackbar('Upload a profile picture to preview it');
    }
  }

  /// Clear the current image file and cached profile picture.
  void clearImage() {
    setState(() {
      _imageFile = null;
      authProvider.clearCachedPic();
    });
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
                            child: Text(
                              'Personalize Your Presence',
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
                                  Hero(
                                    tag: 'Avatar',
                                    child: GestureDetector(
                                      onTap: viewPic,
                                      child: SizedBox(
                                        height: 170,
                                        width: 170,
                                        child: FileProfilePic(
                                          imageFile: data.profilePic,
                                        ),
                                      ),
                                    ),
                                  ),
                                  UploadPhotoWidget(
                                    onTap: () => _pickImage(),
                                  )
                                ],
                              ),
                            ],
                          ),
                          addHeight(32),
                          Text(
                            data.username ?? 'No name set',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blackColor,
                              letterSpacing: 0.6,
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
                            onPressed: createUser,
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
