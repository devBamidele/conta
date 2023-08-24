import 'package:conta/res/components/app_bar_icon.dart';
import 'package:flutter/material.dart';

import '../../../utils/widget_functions.dart';
import '../../color.dart';
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
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _isSearchModeActive = false;

  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleSearchMode() {
    if (_isSearchModeActive) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      _isSearchModeActive = !_isSearchModeActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return AppBar(
          leading: const CustomBackButton(
            color: AppColors.hintTextColor,
            size: 24,
            padding: EdgeInsets.only(left: 16),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: _toggleSearchMode,
                child: _isSearchModeActive
                    ? const AppBarIcon(
                        icon: Icons.close,
                        size: 28,
                      )
                    : searchIcon(),
              ),
            ),
          ],
          title: _isSearchModeActive
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: TextField(
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      hintText: 'Search ...',
                    ),
                  ),
                )
              : const Column(
                  children: [
                    Text(
                      'Select contact',
                      style: TextStyle(
                        color: AppColors.blackColor,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
