import 'package:auto_route/auto_route.dart';
import 'package:conta/utils/app_router/router.gr.dart';
import 'package:conta/utils/services/messaging_service.dart';
import 'package:flutter/material.dart';

import '../../../res/style/component_style.dart';
import '../../../utils/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const tag = '/profile_screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AuthService _authService = AuthService();
  late final MessagingService _messagingService = MessagingService();

  logout() {
    _messagingService.signOutFromMessaging();
    _authService.signOutFromApp();
    context.router.replaceAll([const LoginScreenRoute()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          style: elevatedButton,
          onPressed: logout,
          child: const Text(
            'Log Out',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
