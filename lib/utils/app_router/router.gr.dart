// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:io' as _i29;

import 'package:auto_route/auto_route.dart' as _i24;
import 'package:cloud_firestore/cloud_firestore.dart' as _i28;
import 'package:conta/models/response.dart' as _i27;
import 'package:conta/res/components/image_views/view_image_screen.dart'
    as _i11;
import 'package:conta/view/account_setup/set_name_screen.dart' as _i2;
import 'package:conta/view/account_setup/set_photo_page.dart' as _i3;
import 'package:conta/view/account_setup/sign_up_screen.dart' as _i5;
import 'package:conta/view/account_setup/verify_account_screen.dart' as _i4;
import 'package:conta/view/authentication/login_screen.dart' as _i7;
import 'package:conta/view/authentication/recover_password_screen.dart' as _i6;
import 'package:conta/view/authentication/update_password_screen.dart' as _i8;
import 'package:conta/view/home/home_screen.dart' as _i13;
import 'package:conta/view/home/intermediary.dart' as _i9;
import 'package:conta/view/home/profile_view/blocked_contacts_screen.dart'
    as _i17;
import 'package:conta/view/home/profile_view/edit_profile_info/change_password/update_password.dart'
    as _i21;
import 'package:conta/view/home/profile_view/edit_profile_info/change_password/verify_password.dart'
    as _i19;
import 'package:conta/view/home/profile_view/edit_profile_info/edit_bio_screen.dart'
    as _i18;
import 'package:conta/view/home/profile_view/edit_profile_info/edit_username_screen.dart'
    as _i20;
import 'package:conta/view/home/profile_view/file_image_preview.dart' as _i23;
import 'package:conta/view/home/profile_view/profile_image_preview.dart'
    as _i22;
import 'package:conta/view/home/profile_view/profile_screen.dart' as _i12;
import 'package:conta/view/home/tab_views/message_view/chat_screen.dart'
    as _i14;
import 'package:conta/view/home/tab_views/message_view/contacts_view.dart'
    as _i15;
import 'package:conta/view/home/tab_views/message_view/preview_screen.dart'
    as _i10;
import 'package:conta/view/home/tab_views/message_view/user_pic_view.dart'
    as _i16;
import 'package:conta/view/onboard/splash_screen.dart' as _i1;
import 'package:firebase_auth/firebase_auth.dart' as _i26;
import 'package:flutter/material.dart' as _i25;

class AppRouter extends _i24.RootStackRouter {
  AppRouter([_i25.GlobalKey<_i25.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i24.PageFactory> pagesMap = {
    SplashScreenRoute.name: (routeData) {
      return _i24.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.SplashScreen(),
      );
    },
    SetNameScreenRoute.name: (routeData) {
      return _i24.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i2.SetNameScreen(),
      );
    },
    SetPhotoScreenRoute.name: (routeData) {
      return _i24.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i3.SetPhotoScreen(),
      );
    },
    VerifyAccountScreenRoute.name: (routeData) {
      final args = routeData.argsAs<VerifyAccountScreenRouteArgs>();
      return _i24.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i4.VerifyAccountScreen(
          key: args.key,
          userCredential: args.userCredential,
        ),
      );
    },
    SignUpScreenRoute.name: (routeData) {
      return _i24.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i5.SignUpScreen(),
      );
    },
    RecoverPasswordScreenRoute.name: (routeData) {
      return _i24.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i6.RecoverPasswordScreen(),
      );
    },
    LoginScreenRoute.name: (routeData) {
      return _i24.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i7.LoginScreen(),
      );
    },
    UpdatePasswordScreenRoute.name: (routeData) {
      final args = routeData.argsAs<UpdatePasswordScreenRouteArgs>();
      return _i24.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i8.UpdatePasswordScreen(
          key: args.key,
          email: args.email,
          pop: args.pop,
        ),
      );
    },
    IntermediaryRoute.name: (routeData) {
      final args = routeData.argsAs<IntermediaryRouteArgs>();
      return _i24.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i9.Intermediary(
          key: args.key,
          data: args.data,
        ),
      );
    },
    PreviewScreenRoute.name: (routeData) {
      return _i24.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i10.PreviewScreen(),
      );
    },
    ViewImageScreenRoute.name: (routeData) {
      final args = routeData.argsAs<ViewImageScreenRouteArgs>();
      return _i24.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i11.ViewImageScreen(
          key: args.key,
          media: args.media,
          sender: args.sender,
          timeSent: args.timeSent,
        ),
      );
    },
    ProfileScreenRoute.name: (routeData) {
      return _i24.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i12.ProfileScreen(),
      );
    },
    HomeScreenRoute.name: (routeData) {
      return _i24.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i13.HomeScreen(),
      );
    },
    ChatScreenRoute.name: (routeData) {
      return _i24.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i14.ChatScreen(),
      );
    },
    ContactsViewRoute.name: (routeData) {
      return _i24.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i15.ContactsView(),
      );
    },
    UserPicViewRoute.name: (routeData) {
      final args = routeData.argsAs<UserPicViewRouteArgs>();
      return _i24.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i16.UserPicView(
          key: args.key,
          tag: args.tag,
          path: args.path,
          username: args.username,
          samePerson: args.samePerson,
        ),
      );
    },
    BlockedContactsScreenRoute.name: (routeData) {
      return _i24.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i17.BlockedContactsScreen(),
        transitionsBuilder: _i24.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 150,
        reverseDurationInMilliseconds: 150,
        opaque: true,
        barrierDismissible: false,
      );
    },
    EditBioScreenRoute.name: (routeData) {
      return _i24.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i18.EditBioScreen(),
        transitionsBuilder: _i24.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 150,
        reverseDurationInMilliseconds: 150,
        opaque: true,
        barrierDismissible: false,
      );
    },
    VerifyPasswordRoute.name: (routeData) {
      return _i24.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i19.VerifyPassword(),
        transitionsBuilder: _i24.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 150,
        reverseDurationInMilliseconds: 150,
        opaque: true,
        barrierDismissible: false,
      );
    },
    EditUsernameScreenRoute.name: (routeData) {
      return _i24.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i20.EditUsernameScreen(),
        transitionsBuilder: _i24.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 150,
        reverseDurationInMilliseconds: 150,
        opaque: true,
        barrierDismissible: false,
      );
    },
    UpdatePasswordRoute.name: (routeData) {
      final args = routeData.argsAs<UpdatePasswordRouteArgs>();
      return _i24.CustomPage<dynamic>(
        routeData: routeData,
        child: _i21.UpdatePassword(
          key: args.key,
          oldPassword: args.oldPassword,
        ),
        transitionsBuilder: _i24.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 150,
        reverseDurationInMilliseconds: 150,
        opaque: true,
        barrierDismissible: false,
      );
    },
    ProfileImagePreviewRoute.name: (routeData) {
      final args = routeData.argsAs<ProfileImagePreviewRouteArgs>();
      return _i24.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i22.ProfileImagePreview(
          key: args.key,
          path: args.path,
        ),
      );
    },
    FileImagePreviewRoute.name: (routeData) {
      final args = routeData.argsAs<FileImagePreviewRouteArgs>(
          orElse: () => const FileImagePreviewRouteArgs());
      return _i24.AdaptivePage<bool?>(
        routeData: routeData,
        child: _i23.FileImagePreview(
          key: args.key,
          imageFile: args.imageFile,
          fromSignUp: args.fromSignUp,
        ),
      );
    },
  };

  @override
  List<_i24.RouteConfig> get routes => [
        _i24.RouteConfig(
          SplashScreenRoute.name,
          path: '/',
        ),
        _i24.RouteConfig(
          SetNameScreenRoute.name,
          path: '/set-name-screen',
        ),
        _i24.RouteConfig(
          SetPhotoScreenRoute.name,
          path: '/set-photo-screen',
        ),
        _i24.RouteConfig(
          VerifyAccountScreenRoute.name,
          path: '/verify-account-screen',
        ),
        _i24.RouteConfig(
          SignUpScreenRoute.name,
          path: '/sign-up-screen',
        ),
        _i24.RouteConfig(
          RecoverPasswordScreenRoute.name,
          path: '/recover-password-screen',
        ),
        _i24.RouteConfig(
          LoginScreenRoute.name,
          path: '/login-screen',
        ),
        _i24.RouteConfig(
          UpdatePasswordScreenRoute.name,
          path: '/update-password-screen',
        ),
        _i24.RouteConfig(
          IntermediaryRoute.name,
          path: '/Intermediary',
        ),
        _i24.RouteConfig(
          PreviewScreenRoute.name,
          path: '/preview-screen',
        ),
        _i24.RouteConfig(
          ViewImageScreenRoute.name,
          path: '/view-image-screen',
        ),
        _i24.RouteConfig(
          ProfileScreenRoute.name,
          path: '/profile-screen',
        ),
        _i24.RouteConfig(
          HomeScreenRoute.name,
          path: '/home-screen',
        ),
        _i24.RouteConfig(
          ChatScreenRoute.name,
          path: '/chat-screen',
        ),
        _i24.RouteConfig(
          ContactsViewRoute.name,
          path: '/contacts-view',
        ),
        _i24.RouteConfig(
          UserPicViewRoute.name,
          path: '/user-pic-view',
        ),
        _i24.RouteConfig(
          BlockedContactsScreenRoute.name,
          path: '/blocked-contacts-screen',
        ),
        _i24.RouteConfig(
          EditBioScreenRoute.name,
          path: '/edit-bio-screen',
        ),
        _i24.RouteConfig(
          VerifyPasswordRoute.name,
          path: '/verify-password',
        ),
        _i24.RouteConfig(
          EditUsernameScreenRoute.name,
          path: '/edit-username-screen',
        ),
        _i24.RouteConfig(
          UpdatePasswordRoute.name,
          path: '/update-password',
        ),
        _i24.RouteConfig(
          ProfileImagePreviewRoute.name,
          path: '/profile-image-preview',
        ),
        _i24.RouteConfig(
          FileImagePreviewRoute.name,
          path: '/file-image-preview',
        ),
      ];
}

/// generated route for
/// [_i1.SplashScreen]
class SplashScreenRoute extends _i24.PageRouteInfo<void> {
  const SplashScreenRoute()
      : super(
          SplashScreenRoute.name,
          path: '/',
        );

  static const String name = 'SplashScreenRoute';
}

/// generated route for
/// [_i2.SetNameScreen]
class SetNameScreenRoute extends _i24.PageRouteInfo<void> {
  const SetNameScreenRoute()
      : super(
          SetNameScreenRoute.name,
          path: '/set-name-screen',
        );

  static const String name = 'SetNameScreenRoute';
}

/// generated route for
/// [_i3.SetPhotoScreen]
class SetPhotoScreenRoute extends _i24.PageRouteInfo<void> {
  const SetPhotoScreenRoute()
      : super(
          SetPhotoScreenRoute.name,
          path: '/set-photo-screen',
        );

  static const String name = 'SetPhotoScreenRoute';
}

/// generated route for
/// [_i4.VerifyAccountScreen]
class VerifyAccountScreenRoute
    extends _i24.PageRouteInfo<VerifyAccountScreenRouteArgs> {
  VerifyAccountScreenRoute({
    _i25.Key? key,
    required _i26.UserCredential userCredential,
  }) : super(
          VerifyAccountScreenRoute.name,
          path: '/verify-account-screen',
          args: VerifyAccountScreenRouteArgs(
            key: key,
            userCredential: userCredential,
          ),
        );

  static const String name = 'VerifyAccountScreenRoute';
}

class VerifyAccountScreenRouteArgs {
  const VerifyAccountScreenRouteArgs({
    this.key,
    required this.userCredential,
  });

  final _i25.Key? key;

  final _i26.UserCredential userCredential;

  @override
  String toString() {
    return 'VerifyAccountScreenRouteArgs{key: $key, userCredential: $userCredential}';
  }
}

/// generated route for
/// [_i5.SignUpScreen]
class SignUpScreenRoute extends _i24.PageRouteInfo<void> {
  const SignUpScreenRoute()
      : super(
          SignUpScreenRoute.name,
          path: '/sign-up-screen',
        );

  static const String name = 'SignUpScreenRoute';
}

/// generated route for
/// [_i6.RecoverPasswordScreen]
class RecoverPasswordScreenRoute extends _i24.PageRouteInfo<void> {
  const RecoverPasswordScreenRoute()
      : super(
          RecoverPasswordScreenRoute.name,
          path: '/recover-password-screen',
        );

  static const String name = 'RecoverPasswordScreenRoute';
}

/// generated route for
/// [_i7.LoginScreen]
class LoginScreenRoute extends _i24.PageRouteInfo<void> {
  const LoginScreenRoute()
      : super(
          LoginScreenRoute.name,
          path: '/login-screen',
        );

  static const String name = 'LoginScreenRoute';
}

/// generated route for
/// [_i8.UpdatePasswordScreen]
class UpdatePasswordScreenRoute
    extends _i24.PageRouteInfo<UpdatePasswordScreenRouteArgs> {
  UpdatePasswordScreenRoute({
    _i25.Key? key,
    required String email,
    bool pop = false,
  }) : super(
          UpdatePasswordScreenRoute.name,
          path: '/update-password-screen',
          args: UpdatePasswordScreenRouteArgs(
            key: key,
            email: email,
            pop: pop,
          ),
        );

  static const String name = 'UpdatePasswordScreenRoute';
}

class UpdatePasswordScreenRouteArgs {
  const UpdatePasswordScreenRouteArgs({
    this.key,
    required this.email,
    this.pop = false,
  });

  final _i25.Key? key;

  final String email;

  final bool pop;

  @override
  String toString() {
    return 'UpdatePasswordScreenRouteArgs{key: $key, email: $email, pop: $pop}';
  }
}

/// generated route for
/// [_i9.Intermediary]
class IntermediaryRoute extends _i24.PageRouteInfo<IntermediaryRouteArgs> {
  IntermediaryRoute({
    _i25.Key? key,
    required _i27.Response data,
  }) : super(
          IntermediaryRoute.name,
          path: '/Intermediary',
          args: IntermediaryRouteArgs(
            key: key,
            data: data,
          ),
        );

  static const String name = 'IntermediaryRoute';
}

class IntermediaryRouteArgs {
  const IntermediaryRouteArgs({
    this.key,
    required this.data,
  });

  final _i25.Key? key;

  final _i27.Response data;

  @override
  String toString() {
    return 'IntermediaryRouteArgs{key: $key, data: $data}';
  }
}

/// generated route for
/// [_i10.PreviewScreen]
class PreviewScreenRoute extends _i24.PageRouteInfo<void> {
  const PreviewScreenRoute()
      : super(
          PreviewScreenRoute.name,
          path: '/preview-screen',
        );

  static const String name = 'PreviewScreenRoute';
}

/// generated route for
/// [_i11.ViewImageScreen]
class ViewImageScreenRoute
    extends _i24.PageRouteInfo<ViewImageScreenRouteArgs> {
  ViewImageScreenRoute({
    _i25.Key? key,
    required List<String> media,
    required String sender,
    required _i28.Timestamp timeSent,
  }) : super(
          ViewImageScreenRoute.name,
          path: '/view-image-screen',
          args: ViewImageScreenRouteArgs(
            key: key,
            media: media,
            sender: sender,
            timeSent: timeSent,
          ),
        );

  static const String name = 'ViewImageScreenRoute';
}

class ViewImageScreenRouteArgs {
  const ViewImageScreenRouteArgs({
    this.key,
    required this.media,
    required this.sender,
    required this.timeSent,
  });

  final _i25.Key? key;

  final List<String> media;

  final String sender;

  final _i28.Timestamp timeSent;

  @override
  String toString() {
    return 'ViewImageScreenRouteArgs{key: $key, media: $media, sender: $sender, timeSent: $timeSent}';
  }
}

/// generated route for
/// [_i12.ProfileScreen]
class ProfileScreenRoute extends _i24.PageRouteInfo<void> {
  const ProfileScreenRoute()
      : super(
          ProfileScreenRoute.name,
          path: '/profile-screen',
        );

  static const String name = 'ProfileScreenRoute';
}

/// generated route for
/// [_i13.HomeScreen]
class HomeScreenRoute extends _i24.PageRouteInfo<void> {
  const HomeScreenRoute()
      : super(
          HomeScreenRoute.name,
          path: '/home-screen',
        );

  static const String name = 'HomeScreenRoute';
}

/// generated route for
/// [_i14.ChatScreen]
class ChatScreenRoute extends _i24.PageRouteInfo<void> {
  const ChatScreenRoute()
      : super(
          ChatScreenRoute.name,
          path: '/chat-screen',
        );

  static const String name = 'ChatScreenRoute';
}

/// generated route for
/// [_i15.ContactsView]
class ContactsViewRoute extends _i24.PageRouteInfo<void> {
  const ContactsViewRoute()
      : super(
          ContactsViewRoute.name,
          path: '/contacts-view',
        );

  static const String name = 'ContactsViewRoute';
}

/// generated route for
/// [_i16.UserPicView]
class UserPicViewRoute extends _i24.PageRouteInfo<UserPicViewRouteArgs> {
  UserPicViewRoute({
    _i25.Key? key,
    required String tag,
    required String path,
    required String username,
    required bool samePerson,
  }) : super(
          UserPicViewRoute.name,
          path: '/user-pic-view',
          args: UserPicViewRouteArgs(
            key: key,
            tag: tag,
            path: path,
            username: username,
            samePerson: samePerson,
          ),
        );

  static const String name = 'UserPicViewRoute';
}

class UserPicViewRouteArgs {
  const UserPicViewRouteArgs({
    this.key,
    required this.tag,
    required this.path,
    required this.username,
    required this.samePerson,
  });

  final _i25.Key? key;

  final String tag;

  final String path;

  final String username;

  final bool samePerson;

  @override
  String toString() {
    return 'UserPicViewRouteArgs{key: $key, tag: $tag, path: $path, username: $username, samePerson: $samePerson}';
  }
}

/// generated route for
/// [_i17.BlockedContactsScreen]
class BlockedContactsScreenRoute extends _i24.PageRouteInfo<void> {
  const BlockedContactsScreenRoute()
      : super(
          BlockedContactsScreenRoute.name,
          path: '/blocked-contacts-screen',
        );

  static const String name = 'BlockedContactsScreenRoute';
}

/// generated route for
/// [_i18.EditBioScreen]
class EditBioScreenRoute extends _i24.PageRouteInfo<void> {
  const EditBioScreenRoute()
      : super(
          EditBioScreenRoute.name,
          path: '/edit-bio-screen',
        );

  static const String name = 'EditBioScreenRoute';
}

/// generated route for
/// [_i19.VerifyPassword]
class VerifyPasswordRoute extends _i24.PageRouteInfo<void> {
  const VerifyPasswordRoute()
      : super(
          VerifyPasswordRoute.name,
          path: '/verify-password',
        );

  static const String name = 'VerifyPasswordRoute';
}

/// generated route for
/// [_i20.EditUsernameScreen]
class EditUsernameScreenRoute extends _i24.PageRouteInfo<void> {
  const EditUsernameScreenRoute()
      : super(
          EditUsernameScreenRoute.name,
          path: '/edit-username-screen',
        );

  static const String name = 'EditUsernameScreenRoute';
}

/// generated route for
/// [_i21.UpdatePassword]
class UpdatePasswordRoute extends _i24.PageRouteInfo<UpdatePasswordRouteArgs> {
  UpdatePasswordRoute({
    _i25.Key? key,
    required String oldPassword,
  }) : super(
          UpdatePasswordRoute.name,
          path: '/update-password',
          args: UpdatePasswordRouteArgs(
            key: key,
            oldPassword: oldPassword,
          ),
        );

  static const String name = 'UpdatePasswordRoute';
}

class UpdatePasswordRouteArgs {
  const UpdatePasswordRouteArgs({
    this.key,
    required this.oldPassword,
  });

  final _i25.Key? key;

  final String oldPassword;

  @override
  String toString() {
    return 'UpdatePasswordRouteArgs{key: $key, oldPassword: $oldPassword}';
  }
}

/// generated route for
/// [_i22.ProfileImagePreview]
class ProfileImagePreviewRoute
    extends _i24.PageRouteInfo<ProfileImagePreviewRouteArgs> {
  ProfileImagePreviewRoute({
    _i25.Key? key,
    required String path,
  }) : super(
          ProfileImagePreviewRoute.name,
          path: '/profile-image-preview',
          args: ProfileImagePreviewRouteArgs(
            key: key,
            path: path,
          ),
        );

  static const String name = 'ProfileImagePreviewRoute';
}

class ProfileImagePreviewRouteArgs {
  const ProfileImagePreviewRouteArgs({
    this.key,
    required this.path,
  });

  final _i25.Key? key;

  final String path;

  @override
  String toString() {
    return 'ProfileImagePreviewRouteArgs{key: $key, path: $path}';
  }
}

/// generated route for
/// [_i23.FileImagePreview]
class FileImagePreviewRoute
    extends _i24.PageRouteInfo<FileImagePreviewRouteArgs> {
  FileImagePreviewRoute({
    _i25.Key? key,
    _i29.File? imageFile,
    bool fromSignUp = false,
  }) : super(
          FileImagePreviewRoute.name,
          path: '/file-image-preview',
          args: FileImagePreviewRouteArgs(
            key: key,
            imageFile: imageFile,
            fromSignUp: fromSignUp,
          ),
        );

  static const String name = 'FileImagePreviewRoute';
}

class FileImagePreviewRouteArgs {
  const FileImagePreviewRouteArgs({
    this.key,
    this.imageFile,
    this.fromSignUp = false,
  });

  final _i25.Key? key;

  final _i29.File? imageFile;

  final bool fromSignUp;

  @override
  String toString() {
    return 'FileImagePreviewRouteArgs{key: $key, imageFile: $imageFile, fromSignUp: $fromSignUp}';
  }
}
