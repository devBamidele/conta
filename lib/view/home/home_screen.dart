import 'package:conta/res/components/custom/custom_fab.dart';
import 'package:conta/res/components/custom/custom_text_field.dart';
import 'package:conta/res/components/profile/profile_pic.dart';
import 'package:conta/res/style/component_style.dart';
import 'package:conta/utils/app_router/router.dart';
import 'package:conta/utils/app_router/router.gr.dart';
import 'package:conta/utils/enums.dart';
import 'package:conta/view/home/tab_views/message_view/chat_list_view.dart';
import 'package:conta/view_model/contacts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../res/color.dart';
import '../../res/style/app_text_style.dart';
import '../../utils/widget_functions.dart';
import '../../view_model/chat_provider.dart';
import '../../view_model/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late UserProvider _userProvider;
  late ChatProvider _chatProvider;
  late ContactsProvider _contactsProvider;

  final searchFocusNode = FocusNode();
  final _searchController = TextEditingController();

  Color fillSearchColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _userProvider = Provider.of<UserProvider>(context, listen: false);

    _chatProvider = Provider.of<ChatProvider>(context, listen: false);

    _contactsProvider = Provider.of<ContactsProvider>(context, listen: false);

    _userProvider.getUserInfo();

    _contactsProvider.getContactsInfo();

    _searchController.addListener(_updateFilter);
  }

  @override
  void dispose() {
    _tabController.dispose();

    searchFocusNode.dispose();
    _searchController.dispose();

    super.dispose();
  }

  _updateFilter() =>
      // Update the value in the provider
      _chatProvider.chatFilter = _searchController.text;

  final _tabs = [
    const Tab(text: 'All'),
    const Tab(text: 'Unread'),
    const Tab(text: 'Muted'),
  ];

  final _tabViews = [
    const ChatListView(),
    const ChatListView(category: MessageCategory.unread),
    const ChatListView(category: MessageCategory.muted),
  ];

  void onPressed() {
    _contactsProvider.updateTrigger(true);

    navPush(context, const ContactsViewRoute());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        floatingActionButton: CustomFAB(
          onPressed: onPressed,
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Duo Talk',
                          style: AppTextStyles.titleText,
                        ),
                        GestureDetector(
                          onTap: () =>
                              navPush(context, const ProfileScreenRoute()),
                          child: const Hero(
                            tag: 'Avatar',
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                              child: UrlProfilePic(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(45, 10, 45, 0),
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: TabBar(
                          controller: _tabController,
                          indicator: tabIndicator,
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          labelColor: Colors.white,
                          unselectedLabelColor: AppColors.extraTextColor,
                          labelStyle: AppTextStyles.tabLabelText,
                          tabs: _tabs,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: CustomTextField(
                      lengthLimit: 30,
                      focusNode: searchFocusNode,
                      textController: _searchController,
                      customFillColor: fillSearchColor,
                      focusedBorderColor: Colors.transparent,
                      hintText: 'Search for contacts',
                      prefixIcon: searchIcon(),
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
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 80,
                  decoration: bottomShade,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
