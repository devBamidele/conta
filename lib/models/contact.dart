class Contact {
  final String id;
  final String name;
  final String username;
  final String email;
  final String? profilePicUrl;
  final bool recentSearch;
  final String otherUserId;

  Contact({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.profilePicUrl,
    this.recentSearch = false,
    required this.otherUserId,
  });

  Contact.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        username = json['username'],
        email = json['email'],
        profilePicUrl = json['profilePicUrl'],
        recentSearch = json['recentSearch'],
        otherUserId = json['otherUserId'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'username': username,
        'email': email,
        'profilePicUrl': profilePicUrl,
        'recentSearch': recentSearch,
        'otherUserId': otherUserId,
      };
}
