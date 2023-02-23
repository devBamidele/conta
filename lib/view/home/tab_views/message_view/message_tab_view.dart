import 'package:conta/view/home/tab_views/message_view/message_list_view.dart';
import 'package:conta/view/home/tab_views/message_view/story_screen.dart';
import 'package:flutter/material.dart';

import '../../../../res/color.dart';
import '../../../../res/components/custom_icon_button.dart';
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
    const MessageListView(),
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
                    onTap: () {},
                    child: const Icon(
                      Icons.search_rounded,
                      size: 26,
                      color: AppColors.inactiveColor,
                    ),
                  ),
                  addWidth(20),
                  Expanded(
                    child: Container(
                      height: 44,
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
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.black,
                          tabs: _tabs,
                        ),
                      ),
                    ),
                  ),
                  addWidth(20),
                  CustomIconButton(
                    onTap: () {},
                    child: const Icon(
                      Icons.search_rounded,
                      size: 26,
                      color: AppColors.inactiveColor,
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
