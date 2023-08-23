import 'package:cached_network_image/cached_network_image.dart';
import 'package:conta/res/components/custom/custom_fab.dart';
import 'package:conta/res/components/custom/custom_text_field.dart';
import 'package:conta/res/style/app_text_style.dart';
import 'package:conta/res/style/component_style.dart';
import 'package:conta/utils/app_router/router.dart';
import 'package:conta/utils/app_router/router.gr.dart';
import 'package:conta/utils/enums.dart';
import 'package:conta/view/home/tab_views/message_view/chat_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../res/color.dart';
import '../../res/components/shimmer/shimmer_widget.dart';
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

  final searchFocusNode = FocusNode();
  final _searchController = TextEditingController();

  Color fillSearchColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _userProvider = Provider.of<UserProvider>(context, listen: false);

    _chatProvider = Provider.of<ChatProvider>(context, listen: false);

    _userProvider.getUserInfo();

    _searchController.addListener(_updateFilter);
  }

  @override
  void dispose() {
    _tabController.dispose();

    searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  _updateFilter() {
    // Update the value in the provider
    _chatProvider.filter = _searchController.text;
  }

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

  void onPressed() => navPush(context, const ContactsViewRoute());

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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () =>
                              navPush(context, const ProfileScreenRoute()),
                          child: Hero(
                            tag: 'Avatar',
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                              child: _buildProfileImage(),
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
                          labelStyle: AppTextStyles.textFieldLabel,
                          tabs: _tabs,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: CustomTextField(
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

  Widget _buildProfileImage() {
    final imageUrl = _userProvider.userData?.profilePicUrl;

    return imageUrl != null
        ? CachedNetworkImage(
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) =>
                const ShimmerWidget.circular(width: 54, height: 54),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          )
        : noProfilePic();
  }
}
