class Response {
  final String username;
  final String uidUser2;
  final String senderProfilePic;
  final String bio;
  final String name;

  Response({
    required this.username,
    required this.uidUser2,
    required this.senderProfilePic,
    required this.bio,
    required this.name,
  });

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      username: json['username'] ?? '',
      uidUser2: json['uidUser2'] ?? '',
      senderProfilePic: json['senderProfilePic'] ?? 'null',
      bio: json['bio'] ?? '',
      name: json['name'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Response(username: $username ,\n'
        ' uidUser2: $uidUser2,\n'
        ' bio: $bio,\n'
        ' name: $name,\n'
        'senderProfilePic: $senderProfilePic)';
  }
}
