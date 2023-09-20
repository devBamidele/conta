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

  void clearSearch(ContactsProvider data) {
    data.clearContactsFilter();

    _searchController.clear();
  }

  Future<bool> onWillPop(ContactsProvider data) async {
    clearSearch(data);

    return true;
  }

  @override
  void dispose() {
    _searchController.dispose();

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
                    onChanged: (text) => data.contactFilter = text,
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
                          size: 28,
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
