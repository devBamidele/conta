import 'package:conta/utils/app_utils.dart';
import 'package:conta/view/home/tab_views/message_view/chat_list_view.dart';
import 'package:conta/view/home/tab_views/message_view/story_screen.dart';
import 'package:conta/view/home/tab_views/message_view/users_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../../../res/color.dart';
import '../../../../res/components/custom/custom_icon_button.dart';
import '../../../../utils/widget_functions.dart';

class MessageTabView extends StatefulWidget {
  const MessageTabView({Key? key}) : super(key: key);

  @override
  State<MessageTabView> createState() => _MessageTabViewState();
}

class _MessageTabViewState extends State<MessageTabView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _selectedColor = AppColors.primaryShadeColor;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 2, vsync: this); // set the number of tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final _tabs = [
    const Tab(text: 'Message'),
    const Tab(text: 'Story'),
  ];

  final _tabViews = [
    const ChatListView(),
    const StoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 25),
              child: Row(
                children: [
                  CustomIconButton(
                    onTap: () {
                      showSearch(
                        context: context,
                        delegate: UsersSearch(),
                      );
                    },
                    child: const Icon(
                      IconlyLight.search,
                      size: 24,
                      color: AppColors.opaqueTextColor,
                    ),
                  ),
                  addWidth(20),
                  Expanded(
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                            color: _selectedColor,
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          labelColor: Colors.white,
                          unselectedLabelColor: AppColors.extraTextColor,
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.3,
                          ),
                          tabs: _tabs,
                        ),
                      ),
                    ),
                  ),
                  addWidth(20),
                  CustomIconButton(
                    onTap: () {
                      // Todo : Reverse the changes
                      final id = FirebaseAuth.instance.currentUser!.uid;
                      AppUtils.showToast(id);
                    },
                    child: const Icon(
                      IconlyLight.edit,
                      size: 24,
                      color: AppColors.opaqueTextColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _tabViews,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
