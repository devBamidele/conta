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
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:conta/view/authentication/sign_up_screen.dart' as _i1;
import 'package:conta/view/home/persistent_tab.dart' as _i2;
import 'package:conta/view/home/tab_views/message_view/chat_screen.dart' as _i3;
import 'package:flutter/material.dart' as _i5;

class AppRouter extends _i4.RootStackRouter {
  AppRouter([_i5.GlobalKey<_i5.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    SignUpScreenRoute.name: (routeData) {
      return _i4.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.SignUpScreen(),
      );
    },
    PersistentTabRoute.name: (routeData) {
      return _i4.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i2.PersistentTab(),
      );
    },
    ChatScreenRoute.name: (routeData) {
      return _i4.CustomPage<dynamic>(
        routeData: routeData,
        child: const _i3.ChatScreen(),
        transitionsBuilder: _i4.TransitionsBuilders.slideLeft,
        durationInMilliseconds: 300,
        opaque: true,
        barrierDismissible: false,
      );
    },
  };

  @override
  List<_i4.RouteConfig> get routes => [
        _i4.RouteConfig(
          SignUpScreenRoute.name,
          path: '/',
        ),
        _i4.RouteConfig(
          PersistentTabRoute.name,
          path: '/persistent_tab_screen',
        ),
        _i4.RouteConfig(
          ChatScreenRoute.name,
          path: '/chat_screen',
        ),
      ];
}

/// generated route for
/// [_i1.SignUpScreen]
class SignUpScreenRoute extends _i4.PageRouteInfo<void> {
  const SignUpScreenRoute()
      : super(
          SignUpScreenRoute.name,
          path: '/',
        );

  static const String name = 'SignUpScreenRoute';
}

/// generated route for
/// [_i2.PersistentTab]
class PersistentTabRoute extends _i4.PageRouteInfo<void> {
  const PersistentTabRoute()
      : super(
          PersistentTabRoute.name,
          path: '/persistent_tab_screen',
        );

  static const String name = 'PersistentTabRoute';
}

/// generated route for
/// [_i3.ChatScreen]
class ChatScreenRoute extends _i4.PageRouteInfo<void> {
  const ChatScreenRoute()
      : super(
          ChatScreenRoute.name,
          path: '/chat_screen',
        );

  static const String name = 'ChatScreenRoute';
}
