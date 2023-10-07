import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../utils/widget_functions.dart';
import '../../../view_model/chat_provider.dart';
import '../../color.dart';
import '../../style/component_style.dart';
import '../app_bar_icon.dart';
import '../custom/custom_back_button.dart';

class BlockedAccountsAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  const BlockedAccountsAppBar({super.key});

  @override
  State<BlockedAccountsAppBar> createState() => _BlockedAccountsAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(58);
}

class _BlockedAccountsAppBarState extends State<BlockedAccountsAppBar> {
  bool _isSearchModeActive = false;
  bool _isTextFieldEmpty = true;

  final _searchController = TextEditingController();

  final double _myToolBarHeight = 50;

  void _toggleSearchMode() {
    setState(() => _isSearchModeActive = !_isSearchModeActive);
  }

  @override
  void initState() {
    _searchController.addListener(_updateCloseIcon);

    super.initState();
  }

  void _updateCloseIcon() {
    setState(() {
      _isTextFieldEmpty = _searchController.text.isEmpty;
    });
  }

  void onUpdate(String text, ChatProvider data) {
    data.blockedFilter = text;
  }

  void clearSearch(ChatProvider data) {
    data.clearBlockedFilter();

    _searchController.clear();
  }

  Future<bool> onWillPop(ChatProvider data) async {
    clearSearch(data);

    return true;
  }

  void _chooseAction() {
    _isSearchModeActive ? _toggleSearchMode() : context.router.pop();
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (_, data, __) {
        return WillPopScope(
          onWillPop: () => onWillPop(data),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            child: _isSearchModeActive
                ? AppBar(
                    toolbarHeight: _myToolBarHeight,
                    titleSpacing: 0,
                    key: const ValueKey<bool>(true),
                    leading: CustomBackButton(
                      size: 24,
                      padding: const EdgeInsets.only(left: 20),
                      action: _chooseAction,
                    ),
                    title: Column(
                      children: [
                        const SizedBox.square(
                          dimension: 10,
                        ),
                        SizedBox(
                          height: _myToolBarHeight,
                          child: TextField(
                            controller: _searchController,
                            cursorColor: AppColors.blackColor,
                            onChanged: (text) => onUpdate(text, data),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(15)
                            ],
                            style: const TextStyle(
                              fontSize: 18,
                              height: 1.2,
                              color: AppColors.blackColor,
                            ),
                            decoration: textFieldDecoration,
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: _isTextFieldEmpty
                            ? const SizedBox.shrink()
                            : GestureDetector(
                                onTap: () => clearSearch(data),
                                child: const AppBarIcon(
                                  icon: Icons.close,
                                  size: 24,
                                  color: AppColors.blackColor,
                                ),
                              ),
                      ),
                    ],
                  )
                : AppBar(
                    toolbarHeight: _myToolBarHeight,
                    key: const ValueKey<bool>(false),
                    leading: const CustomBackButton(
                      size: 24,
                      padding: EdgeInsets.only(left: 20),
                    ),
                    title: const Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Text(
                        'Blocked chats',
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: GestureDetector(
                          onTap: _toggleSearchMode,
                          child: searchIcon(color: AppColors.blackColor),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
