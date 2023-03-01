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
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:conta/view/account_setup/set_name_screen.dart' as _i2;
import 'package:conta/view/account_setup/set_photo_page.dart' as _i3;
import 'package:conta/view/authentication/forgot_password_screen.dart' as _i4;
import 'package:conta/view/authentication/login_screen.dart' as _i5;
import 'package:conta/view/authentication/sign_up_screen.dart' as _i1;
import 'package:conta/view/home/persistent_tab.dart' as _i6;
import 'package:conta/view/home/tab_views/message_view/chat_screen.dart' as _i7;
import 'package:firebase_auth/firebase_auth.dart' as _i10;
import 'package:flutter/material.dart' as _i9;

class AppRouter extends _i8.RootStackRouter {
  AppRouter([_i9.GlobalKey<_i9.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i8.PageFactory> pagesMap = {
    SignUpScreenRoute.name: (routeData) {
      return _i8.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.SignUpScreen(),
      );
    },
    SetNameScreenRoute.name: (routeData) {
      final args = routeData.argsAs<SetNameScreenRouteArgs>();
      return _i8.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i2.SetNameScreen(
          key: args.key,
          credential: args.credential,
        ),
      );
    },
    SetPhotoScreenRoute.name: (routeData) {
      return _i8.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i3.SetPhotoScreen(),
      );
    },
    ForgotPasswordScreenRoute.name: (routeData) {
      return _i8.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i4.ForgotPasswordScreen(),
      );
    },
    LoginScreenRoute.name: (routeData) {
      return _i8.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i5.LoginScreen(),
      );
    },
    PersistentTabRoute.name: (routeData) {
      return _i8.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i6.PersistentTab(),
      );
    },
    ChatScreenRoute.name: (routeData) {
      return _i8.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i7.ChatScreen(),
        transitionsBuilder: _i8.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 300,
        opaque: true,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<_i8.RouteConfig> get routes => [
        _i8.RouteConfig(
          SignUpScreenRoute.name,
          path: '/',
        ),
        _i8.RouteConfig(
          SetNameScreenRoute.name,
          path: '/set_name_screen',
        ),
        _i8.RouteConfig(
          SetPhotoScreenRoute.name,
          path: '/set_photo_screen',
        ),
        _i8.RouteConfig(
          ForgotPasswordScreenRoute.name,
          path: '/forgot_password_screen',
        ),
        _i8.RouteConfig(
          LoginScreenRoute.name,
          path: '/login_screen',
        ),
        _i8.RouteConfig(
          PersistentTabRoute.name,
          path: '/persistent_tab_screen',
        ),
        _i8.RouteConfig(
          ChatScreenRoute.name,
          path: '/chat_screen',
        ),
      ];
}

/// generated route for
/// [_i1.SignUpScreen]
class SignUpScreenRoute extends _i8.PageRouteInfo<void> {
  const SignUpScreenRoute()
      : super(
          SignUpScreenRoute.name,
          path: '/',
        );

  static const String name = 'SignUpScreenRoute';
}

/// generated route for
/// [_i2.SetNameScreen]
class SetNameScreenRoute extends _i8.PageRouteInfo<SetNameScreenRouteArgs> {
  SetNameScreenRoute({
    _i9.Key? key,
    required _i10.UserCredential credential,
  }) : super(
          SetNameScreenRoute.name,
          path: '/set_name_screen',
          args: SetNameScreenRouteArgs(
            key: key,
            credential: credential,
          ),
        );

  static const String name = 'SetNameScreenRoute';
}

class SetNameScreenRouteArgs {
  const SetNameScreenRouteArgs({
    this.key,
    required this.credential,
  });

  final _i9.Key? key;

  final _i10.UserCredential credential;

  @override
  String toString() {
    return 'SetNameScreenRouteArgs{key: $key, credential: $credential}';
  }
}

/// generated route for
/// [_i3.SetPhotoScreen]
class SetPhotoScreenRoute extends _i8.PageRouteInfo<void> {
  const SetPhotoScreenRoute()
      : super(
          SetPhotoScreenRoute.name,
          path: '/set_photo_screen',
        );

  static const String name = 'SetPhotoScreenRoute';
}

/// generated route for
/// [_i4.ForgotPasswordScreen]
class ForgotPasswordScreenRoute extends _i8.PageRouteInfo<void> {
  const ForgotPasswordScreenRoute()
      : super(
          ForgotPasswordScreenRoute.name,
          path: '/forgot_password_screen',
        );

  static const String name = 'ForgotPasswordScreenRoute';
}

/// generated route for
/// [_i5.LoginScreen]
class LoginScreenRoute extends _i8.PageRouteInfo<void> {
  const LoginScreenRoute()
      : super(
          LoginScreenRoute.name,
          path: '/login_screen',
        );

  static const String name = 'LoginScreenRoute';
}

/// generated route for
/// [_i6.PersistentTab]
class PersistentTabRoute extends _i8.PageRouteInfo<void> {
  const PersistentTabRoute()
      : super(
          PersistentTabRoute.name,
          path: '/persistent_tab_screen',
        );

  static const String name = 'PersistentTabRoute';
}

/// generated route for
/// [_i7.ChatScreen]
class ChatScreenRoute extends _i8.PageRouteInfo<void> {
  const ChatScreenRoute()
      : super(
          ChatScreenRoute.name,
          path: '/chat_screen',
        );

  static const String name = 'ChatScreenRoute';
}
