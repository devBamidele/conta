class Chat {
  final String id;
  final String user1Id;
  final String user2Id;
  final String? lastSeenUserId;
  final bool muted;

  Chat({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    this.lastSeenUserId,
    this.muted = false,
  });

  /// Create a Chat object from a JSON representation.
  Chat.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        user1Id = json['user1Id'],
        user2Id = json['user2Id'],
        lastSeenUserId = json['lastSeenUserId'],
        muted = json['muted'];

  /// Convert the Chat object to a JSON representation.
  Map<String, dynamic> toJson() => {
        'id': id,
        'user1Id': user1Id,
        'user2Id': user2Id,
        'lastSeenUserId': lastSeenUserId,
        'muted': muted,
      };

  /// Returns the id of the user in the chat that is not [userId].
  String getOtherUserId(String userId) {
    return userId == user1Id ? user2Id : user1Id;
  }

  /*
  /// Returns a boolean indicating if the chat has any unread messages for [userId].
  Future<bool> isSeen(String userId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(id)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();
    if (querySnapshot.docs.isEmpty) {
      return false;
    }
    final lastMessage =
        Message.fromJson(querySnapshot.docs[0].data() as Map<String, dynamic>);
    return lastMessage.senderId != userId && lastMessage.seen;
  }
   */
}
