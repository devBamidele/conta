import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_router/router.dart';
import '../../../utils/app_router/router.gr.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/services/auth_service.dart';
import '../../../utils/widget_functions.dart';
import '../../color.dart';
import '../../style/app_text_style.dart';
import '../../style/component_style.dart';

class LogoutSheet extends StatelessWidget {
  LogoutSheet({super.key});

  late final AuthService _authService = AuthService();

  logout(BuildContext context) {
    _authService.signOutFromApp();

    navReplaceAll(
      context,
      [const LoginScreenRoute()],
    );

    AppUtils.showSnackbar('Logged out Successfully');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Logout',
                    style: AppTextStyles.sheetTitleText,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Divider(
                      color: Colors.grey[200],
                    ),
                  ),
                  const Text(
                    'Are you sure you want to log out ?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: resendButtonStyle(),
                            onPressed: () => context.router.pop(),
                            child: Text(
                              'Cancel',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.primaryShadeColor,
                                fontSize: 16,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
                        addWidth(20),
                        Expanded(
                          child: ElevatedButton(
                            style: elevatedButton,
                            onPressed: () => logout(context),
                            child: Text(
                              'Yes, Logout',
                              style: AppTextStyles.labelMedium
                                  .copyWith(fontSize: 16, letterSpacing: 0.2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
