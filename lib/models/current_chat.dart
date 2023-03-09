class CurrentChat {
  final String username;
  final String uidUser; // This shows the id of the current logged in user
  final String uidChat;
  final String? profilePicUrl;

  CurrentChat({
    required this.username,
    required this.uidUser,
    required this.uidChat,
    this.profilePicUrl,
  });
}
