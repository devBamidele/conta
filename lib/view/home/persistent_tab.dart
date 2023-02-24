import 'package:conta/res/color.dart';
import 'package:conta/view/home/tab_views/call_screen.dart';
import 'package:conta/view/home/tab_views/message_view/message_tab_view.dart';
import 'package:conta/view/home/tab_views/profile_screen.dart';
import 'package:conta/view/home/tab_views/video_screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class PersistentTab extends StatefulWidget {
  const PersistentTab({Key? key}) : super(key: key);

  static const tag = '/persistent_tab_screen';

  @override
  State<PersistentTab> createState() => _PersistentTabState();
}

class _PersistentTabState extends State<PersistentTab> {
  final inactiveColor = AppColors.inactiveColor;
  final activeColor = AppColors.primaryColor;

  late PersistentTabController _controller;
  late bool _hideNavBar;

  double customSize = 27;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController();
    _hideNavBar = false;
  }

  List<PersistentBottomNavBarItem> _navBarItems() => [
        PersistentBottomNavBarItem(
          activeColorPrimary: activeColor,
          inactiveColorPrimary: inactiveColor,
          iconSize: customSize,
          title: ('Message'),
          icon: const Icon(Icons.message_rounded),
        ),
        PersistentBottomNavBarItem(
          activeColorPrimary: activeColor,
          inactiveColorPrimary: inactiveColor,
          iconSize: customSize,
          title: ('Video'),
          icon: const Icon(Icons.camera_alt_rounded),
        ),
        PersistentBottomNavBarItem(
          activeColorPrimary: activeColor,
          inactiveColorPrimary: inactiveColor,
          iconSize: customSize,
          title: ('Call'),
          icon: const Icon(Icons.call),
        ),
        PersistentBottomNavBarItem(
          activeColorPrimary: activeColor,
          inactiveColorPrimary: inactiveColor,
          iconSize: customSize,
          title: ('Profile'),
          icon: const Icon(Icons.account_circle_outlined),
        ),
      ];

  List<Widget> _buildScreens() => [
        const MessageTabView(),
        const VideoScreen(),
        const CallScreen(),
        const ProfileScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      hideNavigationBar: _hideNavBar,
      screens: _buildScreens(),
      items: _navBarItems(),
      navBarHeight: 65,
      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 250),
      ),
      navBarStyle: NavBarStyle.style12,
    );
  }
}
