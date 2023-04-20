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
import 'package:auto_route/auto_route.dart' as _i10;
import 'package:conta/view/account_setup/set_name_screen.dart' as _i2;
import 'package:conta/view/account_setup/set_photo_page.dart' as _i3;
import 'package:conta/view/account_setup/verify_account_screen.dart' as _i4;
import 'package:conta/view/authentication/forgot_password_screen.dart' as _i6;
import 'package:conta/view/authentication/login_screen.dart' as _i7;
import 'package:conta/view/authentication/sign_up_screen.dart' as _i5;
import 'package:conta/view/home/persistent_tab.dart' as _i8;
import 'package:conta/view/home/tab_views/message_view/chat_screen.dart' as _i9;
import 'package:conta/view/onboard/splash_screen.dart' as _i1;
import 'package:firebase_auth/firebase_auth.dart' as _i12;
import 'package:flutter/material.dart' as _i11;

class AppRouter extends _i10.RootStackRouter {
  AppRouter([_i11.GlobalKey<_i11.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i10.PageFactory> pagesMap = {
    SplashScreenRoute.name: (routeData) {
      return _i10.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.SplashScreen(),
      );
    },
    SetNameScreenRoute.name: (routeData) {
      return _i10.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i2.SetNameScreen(),
      );
    },
    SetPhotoScreenRoute.name: (routeData) {
      return _i10.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i3.SetPhotoScreen(),
      );
    },
    VerifyAccountScreenRoute.name: (routeData) {
      final args = routeData.argsAs<VerifyAccountScreenRouteArgs>();
      return _i10.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i4.VerifyAccountScreen(
          key: args.key,
          userCredential: args.userCredential,
        ),
      );
    },
    SignUpScreenRoute.name: (routeData) {
      return _i10.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i5.SignUpScreen(),
      );
    },
    ForgotPasswordScreenRoute.name: (routeData) {
      return _i10.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i6.ForgotPasswordScreen(),
      );
    },
    LoginScreenRoute.name: (routeData) {
      return _i10.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i7.LoginScreen(),
      );
    },
    PersistentTabRoute.name: (routeData) {
      return _i10.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i8.PersistentTab(),
      );
    },
    ChatScreenRoute.name: (routeData) {
      return _i10.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i9.ChatScreen(),
        transitionsBuilder: _i10.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 150,
        opaque: true,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<_i10.RouteConfig> get routes => [
        _i10.RouteConfig(
          SplashScreenRoute.name,
          path: '/',
        ),
        _i10.RouteConfig(
          SetNameScreenRoute.name,
          path: '/set_name_screen',
        ),
        _i10.RouteConfig(
          SetPhotoScreenRoute.name,
          path: '/set_photo_screen',
        ),
        _i10.RouteConfig(
          VerifyAccountScreenRoute.name,
          path: '/verify_account_screen',
        ),
        _i10.RouteConfig(
          SignUpScreenRoute.name,
          path: '/sign_up_screen',
        ),
        _i10.RouteConfig(
          ForgotPasswordScreenRoute.name,
          path: '/forgot_password_screen',
        ),
        _i10.RouteConfig(
          LoginScreenRoute.name,
          path: '/login_screen',
        ),
        _i10.RouteConfig(
          PersistentTabRoute.name,
          path: '/persistent_tab_screen',
        ),
        _i10.RouteConfig(
          ChatScreenRoute.name,
          path: '/chat_screen',
        ),
      ];
}

/// generated route for
/// [_i1.SplashScreen]
class SplashScreenRoute extends _i10.PageRouteInfo<void> {
  const SplashScreenRoute()
      : super(
          SplashScreenRoute.name,
          path: '/',
        );

  static const String name = 'SplashScreenRoute';
}

/// generated route for
/// [_i2.SetNameScreen]
class SetNameScreenRoute extends _i10.PageRouteInfo<void> {
  const SetNameScreenRoute()
      : super(
          SetNameScreenRoute.name,
          path: '/set_name_screen',
        );

  static const String name = 'SetNameScreenRoute';
}

/// generated route for
/// [_i3.SetPhotoScreen]
class SetPhotoScreenRoute extends _i10.PageRouteInfo<void> {
  const SetPhotoScreenRoute()
      : super(
          SetPhotoScreenRoute.name,
          path: '/set_photo_screen',
        );

  static const String name = 'SetPhotoScreenRoute';
}

/// generated route for
/// [_i4.VerifyAccountScreen]
class VerifyAccountScreenRoute
    extends _i10.PageRouteInfo<VerifyAccountScreenRouteArgs> {
  VerifyAccountScreenRoute({
    _i11.Key? key,
    required _i12.UserCredential userCredential,
  }) : super(
          VerifyAccountScreenRoute.name,
          path: '/verify_account_screen',
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

  final _i11.Key? key;

  final _i12.UserCredential userCredential;

  @override
  String toString() {
    return 'VerifyAccountScreenRouteArgs{key: $key, userCredential: $userCredential}';
  }
}

/// generated route for
/// [_i5.SignUpScreen]
class SignUpScreenRoute extends _i10.PageRouteInfo<void> {
  const SignUpScreenRoute()
      : super(
          SignUpScreenRoute.name,
          path: '/sign_up_screen',
        );

  static const String name = 'SignUpScreenRoute';
}

/// generated route for
/// [_i6.ForgotPasswordScreen]
class ForgotPasswordScreenRoute extends _i10.PageRouteInfo<void> {
  const ForgotPasswordScreenRoute()
      : super(
          ForgotPasswordScreenRoute.name,
          path: '/forgot_password_screen',
        );

  static const String name = 'ForgotPasswordScreenRoute';
}

/// generated route for
/// [_i7.LoginScreen]
class LoginScreenRoute extends _i10.PageRouteInfo<void> {
  const LoginScreenRoute()
      : super(
          LoginScreenRoute.name,
          path: '/login_screen',
        );

  static const String name = 'LoginScreenRoute';
}

/// generated route for
/// [_i8.PersistentTab]
class PersistentTabRoute extends _i10.PageRouteInfo<void> {
  const PersistentTabRoute()
      : super(
          PersistentTabRoute.name,
          path: '/persistent_tab_screen',
        );

  static const String name = 'PersistentTabRoute';
}

/// generated route for
/// [_i9.ChatScreen]
class ChatScreenRoute extends _i10.PageRouteInfo<void> {
  const ChatScreenRoute()
      : super(
          ChatScreenRoute.name,
          path: '/chat_screen',
        );

  static const String name = 'ChatScreenRoute';
}
