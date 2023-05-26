import 'package:flutter/material.dart';

class MessageCounter extends StatefulWidget {
  final int count;

  const MessageCounter({Key? key, required this.count}) : super(key: key);

  @override
  State<MessageCounter> createState() => _MessageCounterState();
}

class _MessageCounterState extends State<MessageCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void didUpdateWidget(MessageCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count != oldWidget.count) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      child: Text(
        '${widget.count}',
        key: ValueKey<int>(widget.count),
        style: const TextStyle(fontSize: 22),
      ),
    );
  }
}

/*

AppBar(
                leading: data.isMessageLongPressed
                    ? Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: AppBarIcon(
                              icon: Icons.close,
                              size: customSize + 2,
                              onTap: () => setState(
                                () => data.resetSelectedMessages(),
                              ),
                            ),
                          ),
                        ],
                      )
                    : CustomBackButton(
                        padding: const EdgeInsets.only(left: 15),
                        color: AppColors.extraTextColor,
                        onPressed: () => data.cancelReply(),
                      ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                      child: data.isMessageLongPressed
                          ? Row(
                              key: const Key('longPressed'),
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (data.selectedMessages.length == 1)
                                  AppBarIcon(
                                    icon: Icons.reply_rounded,
                                    size: customSize,
                                    onTap: () => data.updateReplyByAppBar(),
                                  ),
                                addWidth(20),
                                AppBarIcon(
                                    icon: Icons.content_copy_outlined,
                                    size: customSize - 2,
                                    onTap: () {
                                      data.copyMessageContent();
                                      showToast("Message Copied");
                                    }),
                                addWidth(20),
                                AppBarIcon(
                                  icon: Icons.reply_rounded,
                                  size: customSize,
                                  transform: Matrix4.rotationY(math.pi),
                                ),
                                addWidth(20),
                                AppBarIcon(
                                  icon: IconlyLight.delete,
                                  size: customSize,
                                  onTap: () => confirmDelete(context, data),
                                ),
                              ],
                            )
                          : Row(
                              key: const Key('not-longPressed'),
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                addWidth(10),
                                AppBarIcon(
                                    icon: IconlyLight.video, size: customSize),
                                addWidth(20),
                                AppBarIcon(
                                    icon: IconlyLight.call, size: customSize),
                              ],
                            ),
                    ),
                  ),
                ],
                title: data.isMessageLongPressed
                    ? MessageCounter(
                        count: data.selectedMessages.length,
                      )
                    : Row(
                        children: [
                          CircleAvatar(
                            radius: 23,
                            backgroundColor: Colors.white,
                            child: currentChat.profilePicUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: currentChat.profilePicUrl!,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        const ShimmerWidget.circular(
                                            width: 46, height: 46),
                                    errorWidget: (context, url, error) =>
                                        const ShimmerWidget.circular(
                                            width: 46, height: 46),
                                  )
                                : const Icon(
                                    IconlyBold.profile,
                                    color: Color(0xFF9E9E9E),
                                    size: 25,
                                  ),
                          ),
                          addWidth(10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentChat.username,
                                  overflow: TextOverflow.fade,
                                  style: const TextStyle(
                                    fontSize: 17.5,
                                    height: 1.2,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                addHeight(2),
                                const OnlineStatus(),
                              ],
                            ),
                          ),
                        ],
                      ),
              )

 */
