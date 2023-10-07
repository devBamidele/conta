/// The class representing the current chat between two users.
///
/// The [username] is the username of the chat.
/// The [uidUser1] is the ID of the currently logged-in user.
/// The [uidUser2] is the ID of the other user in the chat.
/// The [profilePicUrl] is the URL of the chat's profile picture (optional).
/// The [chatId] is the ID of the chat (optional).
class CurrentChat {
  final String username;
  final String uidUser1;
  final String uidUser2;
  final bool notifications;
  final String? profilePicUrl;
  final String? chatId;
  final String? bio;
  final int? oppIndex;
  final bool? isDeleted;
  final bool isBlocked;

  /// Constructs a [CurrentChat] object.
  ///
  /// The [username] is the username of the chat.
  /// The [uidUser1] is the ID of the currently logged-in user.
  /// The [uidUser2] is the ID of the other user in the chat.
  /// The [profilePicUrl] is the URL of the chat's profile picture (optional).
  /// The [chatId] is the ID of the chat (optional).
  CurrentChat({
    required this.username,
    required this.uidUser1,
    required this.uidUser2,
    required this.notifications,
    this.profilePicUrl,
    this.chatId,
    this.bio,
    this.oppIndex,
    this.isBlocked = false,
    this.isDeleted = false,
  });

  // Create a copyWith method to clone the object with some modified properties.
  CurrentChat copyWith({
    String? username,
    String? uidUser1,
    String? uidUser2,
    bool? notifications,
    String? profilePicUrl,
    String? chatId,
    String? bio,
    String? phone,
    int? oppIndex,
    bool? isDeleted,
    bool? isBlocked,
  }) {
    return CurrentChat(
      username: username ?? this.username,
      uidUser1: uidUser1 ?? this.uidUser1,
      uidUser2: uidUser2 ?? this.uidUser2,
      notifications: notifications ?? this.notifications,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      chatId: chatId ?? this.chatId,
      bio: bio ?? this.bio,
      oppIndex: oppIndex ?? this.oppIndex,
      isDeleted: isDeleted ?? this.isDeleted,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }
}
