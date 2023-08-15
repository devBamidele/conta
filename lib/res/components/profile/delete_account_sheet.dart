import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../utils/widget_functions.dart';
import '../../color.dart';
import '../../style/app_text_style.dart';
import '../../style/component_style.dart';
import '../custom/custom_text_field.dart';

class DeleteAccountSheet extends StatelessWidget {
  DeleteAccountSheet({super.key});

  final passwordNode = FocusNode();
  final passController = TextEditingController();

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
                    'Delete account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryShadeColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Divider(
                      color: Colors.grey[200],
                    ),
                  ),
                  const Text(
                    'Just making sure it\'s you',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: CustomTextField(
                      focusNode: passwordNode,
                      textController: passController,
                      customFillColor: AppColors.inputBackGround,
                      hintText: 'Password',
                      prefixIcon: lockIcon(AppColors.hintTextColor),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
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
                        addWidth(12),
                        Expanded(
                          child: ElevatedButton(
                            style: elevatedButton,
                            onPressed: () {},
                            child: Text(
                              'Yes, Delete',
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
