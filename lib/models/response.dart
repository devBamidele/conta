class Response {
  final String username;
  final String uidUser2;
  final String senderProfilePic;

  Response({
    required this.username,
    required this.uidUser2,
    required this.senderProfilePic,
  });

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      username: json['username'] ?? '',
      uidUser2: json['uidUser2'] ?? '',
      senderProfilePic: json['senderProfilePic'] ?? 'null',
    );
  }

  @override
  String toString() {
    return 'Response(username: $username ,\n'
        ' uidUser2: $uidUser2,\n'
        'senderProfilePic: $senderProfilePic)';
  }
}
