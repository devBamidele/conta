class Chat {
  final String id;
  final String user1Id;
  final String user2Id;
  final num user1Unread;
  final num user2Unread;
  final bool muted;

  Chat({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.user1Unread,
    required this.user2Unread,
    this.muted = false,
  });

  /// Create a Chat object from a JSON representation.
  Chat.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        user1Id = json['user1Id'],
        user2Id = json['user2Id'],
        user1Unread = json['user1Unread'],
        user2Unread = json['user2Unread'],
        muted = json['muted'];

  /// Convert the Chat object to a JSON representation.
  Map<String, dynamic> toJson() => {
        'id': id,
        'user1Id': user1Id,
        'user2Id': user2Id,
        'user1Unread': user1Unread,
        'user2Unread': user2Unread,
        'muted': muted,
      };

  /// Returns the id of the user in the chat that is not [userId].
  String getOtherUserId(String userId) {
    return userId == user1Id ? user2Id : user1Id;
  }
}
