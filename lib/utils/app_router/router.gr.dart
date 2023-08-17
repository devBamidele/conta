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
import 'package:auto_route/auto_route.dart' as _i17;
import 'package:cloud_firestore/cloud_firestore.dart' as _i22;
import 'package:conta/models/response.dart' as _i21;
import 'package:conta/res/components/image_views/view_image_screen.dart'
    as _i11;
import 'package:conta/view/account_setup/set_name_screen.dart' as _i2;
import 'package:conta/view/account_setup/set_photo_page.dart' as _i3;
import 'package:conta/view/account_setup/sign_up_screen.dart' as _i5;
import 'package:conta/view/account_setup/verify_account_screen.dart' as _i4;
import 'package:conta/view/authentication/login_screen.dart' as _i7;
import 'package:conta/view/authentication/recover_password_screen.dart' as _i6;
import 'package:conta/view/authentication/update_password_screen.dart' as _i8;
import 'package:conta/view/home/edit_profile_info/edit_bio_screen.dart' as _i15;
import 'package:conta/view/home/edit_profile_info/edit_password_screen.dart'
    as _i16;
import 'package:conta/view/home/home_screen.dart' as _i13;
import 'package:conta/view/home/intermediary.dart' as _i9;
import 'package:conta/view/home/tab_views/message_view/chat_screen.dart'
    as _i14;
import 'package:conta/view/home/tab_views/message_view/preview_screen.dart'
    as _i10;
import 'package:conta/view/home/tab_views/profile_screen.dart' as _i12;
import 'package:conta/view/onboard/splash_screen.dart' as _i1;
import 'package:firebase_auth/firebase_auth.dart' as _i20;
import 'package:flutter/cupertino.dart' as _i19;
import 'package:flutter/material.dart' as _i18;

class AppRouter extends _i17.RootStackRouter {
  AppRouter([_i18.GlobalKey<_i18.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i17.PageFactory> pagesMap = {
    SplashScreenRoute.name: (routeData) {
      return _i17.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.SplashScreen(),
      );
    },
    SetNameScreenRoute.name: (routeData) {
      return _i17.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i2.SetNameScreen(),
      );
    },
    SetPhotoScreenRoute.name: (routeData) {
      return _i17.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i3.SetPhotoScreen(),
      );
    },
    VerifyAccountScreenRoute.name: (routeData) {
      final args = routeData.argsAs<VerifyAccountScreenRouteArgs>();
      return _i17.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i4.VerifyAccountScreen(
          key: args.key,
          userCredential: args.userCredential,
        ),
      );
    },
    SignUpScreenRoute.name: (routeData) {
      return _i17.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i5.SignUpScreen(),
      );
    },
    RecoverPasswordScreenRoute.name: (routeData) {
      return _i17.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i6.RecoverPasswordScreen(),
      );
    },
    LoginScreenRoute.name: (routeData) {
      return _i17.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i7.LoginScreen(),
      );
    },
    UpdatePasswordScreenRoute.name: (routeData) {
      final args = routeData.argsAs<UpdatePasswordScreenRouteArgs>();
      return _i17.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i8.UpdatePasswordScreen(
          key: args.key,
          email: args.email,
        ),
      );
    },
    IntermediaryRoute.name: (routeData) {
      final args = routeData.argsAs<IntermediaryRouteArgs>();
      return _i17.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i9.Intermediary(
          key: args.key,
          data: args.data,
        ),
      );
    },
    PreviewScreenRoute.name: (routeData) {
      return _i17.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i10.PreviewScreen(),
      );
    },
    ViewImageScreenRoute.name: (routeData) {
      final args = routeData.argsAs<ViewImageScreenRouteArgs>();
      return _i17.AdaptivePage<dynamic>(
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
      return _i17.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i12.ProfileScreen(),
      );
    },
    HomeScreenRoute.name: (routeData) {
      return _i17.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i13.HomeScreen(),
      );
    },
    ChatScreenRoute.name: (routeData) {
      return _i17.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i14.ChatScreen(),
      );
    },
    EditBioScreenRoute.name: (routeData) {
      return _i17.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i15.EditBioScreen(),
        transitionsBuilder: _i17.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 150,
        opaque: true,
        barrierDismissible: false,
      );
    },
    EditPasswordScreenRoute.name: (routeData) {
      return _i17.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i16.EditPasswordScreen(),
        transitionsBuilder: _i17.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 150,
        opaque: true,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<_i17.RouteConfig> get routes => [
        _i17.RouteConfig(
          SplashScreenRoute.name,
          path: '/',
        ),
        _i17.RouteConfig(
          SetNameScreenRoute.name,
          path: '/set-name-screen',
        ),
        _i17.RouteConfig(
          SetPhotoScreenRoute.name,
          path: '/set-photo-screen',
        ),
        _i17.RouteConfig(
          VerifyAccountScreenRoute.name,
          path: '/verify-account-screen',
        ),
        _i17.RouteConfig(
          SignUpScreenRoute.name,
          path: '/sign-up-screen',
        ),
        _i17.RouteConfig(
          RecoverPasswordScreenRoute.name,
          path: '/recover-password-screen',
        ),
        _i17.RouteConfig(
          LoginScreenRoute.name,
          path: '/login-screen',
        ),
        _i17.RouteConfig(
          UpdatePasswordScreenRoute.name,
          path: '/update-password-screen',
        ),
        _i17.RouteConfig(
          IntermediaryRoute.name,
          path: '/Intermediary',
        ),
        _i17.RouteConfig(
          PreviewScreenRoute.name,
          path: '/preview-screen',
        ),
        _i17.RouteConfig(
          ViewImageScreenRoute.name,
          path: '/view-image-screen',
        ),
        _i17.RouteConfig(
          ProfileScreenRoute.name,
          path: '/profile-screen',
        ),
        _i17.RouteConfig(
          HomeScreenRoute.name,
          path: '/home-screen',
        ),
        _i17.RouteConfig(
          ChatScreenRoute.name,
          path: '/chat-screen',
        ),
        _i17.RouteConfig(
          EditBioScreenRoute.name,
          path: '/edit-bio-screen',
        ),
        _i17.RouteConfig(
          EditPasswordScreenRoute.name,
          path: '/edit-password-screen',
        ),
      ];
}

/// generated route for
/// [_i1.SplashScreen]
class SplashScreenRoute extends _i17.PageRouteInfo<void> {
  const SplashScreenRoute()
      : super(
          SplashScreenRoute.name,
          path: '/',
        );

  static const String name = 'SplashScreenRoute';
}

/// generated route for
/// [_i2.SetNameScreen]
class SetNameScreenRoute extends _i17.PageRouteInfo<void> {
  const SetNameScreenRoute()
      : super(
          SetNameScreenRoute.name,
          path: '/set-name-screen',
        );

  static const String name = 'SetNameScreenRoute';
}

/// generated route for
/// [_i3.SetPhotoScreen]
class SetPhotoScreenRoute extends _i17.PageRouteInfo<void> {
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
    extends _i17.PageRouteInfo<VerifyAccountScreenRouteArgs> {
  VerifyAccountScreenRoute({
    _i19.Key? key,
    required _i20.UserCredential userCredential,
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

  final _i19.Key? key;

  final _i20.UserCredential userCredential;

  @override
  String toString() {
    return 'VerifyAccountScreenRouteArgs{key: $key, userCredential: $userCredential}';
  }
}

/// generated route for
/// [_i5.SignUpScreen]
class SignUpScreenRoute extends _i17.PageRouteInfo<void> {
  const SignUpScreenRoute()
      : super(
          SignUpScreenRoute.name,
          path: '/sign-up-screen',
        );

  static const String name = 'SignUpScreenRoute';
}

/// generated route for
/// [_i6.RecoverPasswordScreen]
class RecoverPasswordScreenRoute extends _i17.PageRouteInfo<void> {
  const RecoverPasswordScreenRoute()
      : super(
          RecoverPasswordScreenRoute.name,
          path: '/recover-password-screen',
        );

  static const String name = 'RecoverPasswordScreenRoute';
}

/// generated route for
/// [_i7.LoginScreen]
class LoginScreenRoute extends _i17.PageRouteInfo<void> {
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
    extends _i17.PageRouteInfo<UpdatePasswordScreenRouteArgs> {
  UpdatePasswordScreenRoute({
    _i19.Key? key,
    required String email,
  }) : super(
          UpdatePasswordScreenRoute.name,
          path: '/update-password-screen',
          args: UpdatePasswordScreenRouteArgs(
            key: key,
            email: email,
          ),
        );

  static const String name = 'UpdatePasswordScreenRoute';
}

class UpdatePasswordScreenRouteArgs {
  const UpdatePasswordScreenRouteArgs({
    this.key,
    required this.email,
  });

  final _i19.Key? key;

  final String email;

  @override
  String toString() {
    return 'UpdatePasswordScreenRouteArgs{key: $key, email: $email}';
  }
}

/// generated route for
/// [_i9.Intermediary]
class IntermediaryRoute extends _i17.PageRouteInfo<IntermediaryRouteArgs> {
  IntermediaryRoute({
    _i19.Key? key,
    required _i21.Response data,
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

  final _i19.Key? key;

  final _i21.Response data;

  @override
  String toString() {
    return 'IntermediaryRouteArgs{key: $key, data: $data}';
  }
}

/// generated route for
/// [_i10.PreviewScreen]
class PreviewScreenRoute extends _i17.PageRouteInfo<void> {
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
    extends _i17.PageRouteInfo<ViewImageScreenRouteArgs> {
  ViewImageScreenRoute({
    _i19.Key? key,
    required List<String> media,
    required String sender,
    required _i22.Timestamp timeSent,
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

  final _i19.Key? key;

  final List<String> media;

  final String sender;

  final _i22.Timestamp timeSent;

  @override
  String toString() {
    return 'ViewImageScreenRouteArgs{key: $key, media: $media, sender: $sender, timeSent: $timeSent}';
  }
}

/// generated route for
/// [_i12.ProfileScreen]
class ProfileScreenRoute extends _i17.PageRouteInfo<void> {
  const ProfileScreenRoute()
      : super(
          ProfileScreenRoute.name,
          path: '/profile-screen',
        );

  static const String name = 'ProfileScreenRoute';
}

/// generated route for
/// [_i13.HomeScreen]
class HomeScreenRoute extends _i17.PageRouteInfo<void> {
  const HomeScreenRoute()
      : super(
          HomeScreenRoute.name,
          path: '/home-screen',
        );

  static const String name = 'HomeScreenRoute';
}

/// generated route for
/// [_i14.ChatScreen]
class ChatScreenRoute extends _i17.PageRouteInfo<void> {
  const ChatScreenRoute()
      : super(
          ChatScreenRoute.name,
          path: '/chat-screen',
        );

  static const String name = 'ChatScreenRoute';
}

/// generated route for
/// [_i15.EditBioScreen]
class EditBioScreenRoute extends _i17.PageRouteInfo<void> {
  const EditBioScreenRoute()
      : super(
          EditBioScreenRoute.name,
          path: '/edit-bio-screen',
        );

  static const String name = 'EditBioScreenRoute';
}

/// generated route for
/// [_i16.EditPasswordScreen]
class EditPasswordScreenRoute extends _i17.PageRouteInfo<void> {
  const EditPasswordScreenRoute()
      : super(
          EditPasswordScreenRoute.name,
          path: '/edit-password-screen',
        );

  static const String name = 'EditPasswordScreenRoute';
}
