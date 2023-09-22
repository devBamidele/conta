class SearchResults {
  final String id;
  final String username;
  final String? phone;
  final String? profilePicUrl;
  final String bio;

  SearchResults({
    required this.id,
    required this.username,
    this.phone,
    this.profilePicUrl,
    required this.bio,
  });

  SearchResults.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? json['objectID'],
        username = json['username'],
        profilePicUrl = json['profilePicUrl'],
        bio = json['bio'],
        phone = json['phone'];
}
