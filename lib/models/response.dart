class Response {
  final String username;
  final String uidUser2;
  final String senderProfilePic;
  final String? bio;
  final String? name;
  final bool notifications;
  final int oppIndex;

  Response({
    required this.username,
    required this.uidUser2,
    required this.senderProfilePic,
    this.bio,
    this.name,
    required this.notifications,
    required this.oppIndex,
  });

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      username: json['username'] as String,
      uidUser2: json['uidUser2'] as String,
      senderProfilePic: json['senderProfilePic'] ?? 'null',
      bio: json['bio'] as String?,
      name: json['name'] as String?,
      notifications: true,
      oppIndex: int.tryParse(json['oppIndex'] as String) ?? 0,
    );
  }

  @override
  String toString() {
    return 'Response(username: $username ,\n'
        ' uidUser2: $uidUser2,\n'
        ' bio: $bio,\n'
        ' name: $name,\n'
        ' notifications $notifications, \n'
        ' oppIndex $oppIndex, \n  '
        'senderProfilePic: $senderProfilePic)';
  }
}
