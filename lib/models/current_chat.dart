class CurrentChat {
  final String username;
  final String uidUser1; // This shows the id of the current logged in user
  final String uidUser2;
  final String? profilePicUrl;
  final String? chatId;

  CurrentChat({
    required this.username,
    required this.uidUser1,
    required this.uidUser2,
    this.profilePicUrl,
    this.chatId,
  });
}
