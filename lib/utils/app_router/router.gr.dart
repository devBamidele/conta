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
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:conta/view/account_setup/set_name_screen.dart' as _i1;
import 'package:conta/view/account_setup/set_photo_page.dart' as _i2;
import 'package:conta/view/authentication/forgot_password_screen.dart' as _i3;
import 'package:conta/view/home/persistent_tab.dart' as _i4;
import 'package:conta/view/home/tab_views/message_view/chat_screen.dart' as _i5;
import 'package:flutter/material.dart' as _i7;

class AppRouter extends _i6.RootStackRouter {
  AppRouter([_i7.GlobalKey<_i7.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    SetNameScreenRoute.name: (routeData) {
      return _i6.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.SetNameScreen(),
      );
    },
    SetPhotoScreenRoute.name: (routeData) {
      return _i6.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i2.SetPhotoScreen(),
      );
    },
    ForgotPasswordScreenRoute.name: (routeData) {
      return _i6.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i3.ForgotPasswordScreen(),
      );
    },
    PersistentTabRoute.name: (routeData) {
      return _i6.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i4.PersistentTab(),
      );
    },
    ChatScreenRoute.name: (routeData) {
      return _i6.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i5.ChatScreen(),
        transitionsBuilder: _i6.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 300,
        opaque: true,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<_i6.RouteConfig> get routes => [
        _i6.RouteConfig(
          SetNameScreenRoute.name,
          path: '/',
        ),
        _i6.RouteConfig(
          SetPhotoScreenRoute.name,
          path: '/set_photo_screen',
        ),
        _i6.RouteConfig(
          ForgotPasswordScreenRoute.name,
          path: '/forgot_password_screen',
        ),
        _i6.RouteConfig(
          PersistentTabRoute.name,
          path: '/persistent_tab_screen',
        ),
        _i6.RouteConfig(
          ChatScreenRoute.name,
          path: '/chat_screen',
        ),
      ];
}

/// generated route for
/// [_i1.SetNameScreen]
class SetNameScreenRoute extends _i6.PageRouteInfo<void> {
  const SetNameScreenRoute()
      : super(
          SetNameScreenRoute.name,
          path: '/',
        );

  static const String name = 'SetNameScreenRoute';
}

/// generated route for
/// [_i2.SetPhotoScreen]
class SetPhotoScreenRoute extends _i6.PageRouteInfo<void> {
  const SetPhotoScreenRoute()
      : super(
          SetPhotoScreenRoute.name,
          path: '/set_photo_screen',
        );

  static const String name = 'SetPhotoScreenRoute';
}

/// generated route for
/// [_i3.ForgotPasswordScreen]
class ForgotPasswordScreenRoute extends _i6.PageRouteInfo<void> {
  const ForgotPasswordScreenRoute()
      : super(
          ForgotPasswordScreenRoute.name,
          path: '/forgot_password_screen',
        );

  static const String name = 'ForgotPasswordScreenRoute';
}

/// generated route for
/// [_i4.PersistentTab]
class PersistentTabRoute extends _i6.PageRouteInfo<void> {
  const PersistentTabRoute()
      : super(
          PersistentTabRoute.name,
          path: '/persistent_tab_screen',
        );

  static const String name = 'PersistentTabRoute';
}

/// generated route for
/// [_i5.ChatScreen]
class ChatScreenRoute extends _i6.PageRouteInfo<void> {
  const ChatScreenRoute()
      : super(
          ChatScreenRoute.name,
          path: '/chat_screen',
        );

  static const String name = 'ChatScreenRoute';
}
