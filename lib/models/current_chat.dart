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
  final String? profilePicUrl;
  final String? chatId;

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
    this.profilePicUrl,
    this.chatId,
  });
}
