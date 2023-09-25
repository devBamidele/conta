import 'dart:async';

import 'package:conta/res/style/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../view_model/contacts_provider.dart';
import '../../color.dart';
import '../../style/component_style.dart';
import '../app_bar_icon.dart';
import '../custom/custom_back_button.dart';

class ContactsAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ContactsAppBar({super.key});

  @override
  State<ContactsAppBar> createState() => _ContactsAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(58);
}

class _ContactsAppBarState extends State<ContactsAppBar>
    with SingleTickerProviderStateMixin {
  bool _isTextFieldEmpty = true;

  final _searchController = TextEditingController();

  final double _myToolBarHeight = 50;

  Timer? _debounce;

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

  void clearSearch({required ContactsProvider data, bool update = false}) {
    data.clearContactsFilter();

    if (update) {
      data.updateTrigger(false);
    }

    _searchController.clear();
  }

  void onFilterChanged({
    required ContactsProvider data,
    required String text,
  }) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 1000),
      () async {
        data.contactFilter = text;
      },
    );
  }

  Future<bool> onWillPop(ContactsProvider data) async {
    clearSearch(data: data, update: true);

    return true;
  }

  @override
  void dispose() {
    _searchController.dispose();

    _debounce?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactsProvider>(
      builder: (_, data, __) {
        return WillPopScope(
          onWillPop: () => onWillPop(data),
          child: AppBar(
            toolbarHeight: _myToolBarHeight,
            titleSpacing: 0,
            key: const ValueKey<bool>(true),
            leading: const CustomBackButton(
              size: 24,
              padding: EdgeInsets.only(left: 20),
            ),
            title: Column(
              children: [
                const SizedBox.square(dimension: 10),
                SizedBox(
                  height: _myToolBarHeight,
                  child: TextField(
                    controller: _searchController,
                    inputFormatters: [LengthLimitingTextInputFormatter(15)],
                    cursorColor: AppColors.blackColor,
                    onChanged: (text) =>
                        onFilterChanged(data: data, text: text),
                    style: AppTextStyles.contactsAppBarText,
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
                        onTap: () => clearSearch(data: data),
                        child: const AppBarIcon(
                          icon: Icons.close,
                          size: 24,
                          color: AppColors.blackColor,
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
