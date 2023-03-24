import 'package:cloud_firestore/cloud_firestore.dart';

class SearchUser {
  final String name;
  final String username;
  final String uidUser; // This shows the id of the current logged in user
  final String uidSearch;
  final String? profilePicUrl;
  final Timestamp timestamp; // The time the item was clicked

  SearchUser({
    required this.timestamp,
    required this.name,
    required this.username,
    required this.uidUser,
    required this.uidSearch,
    this.profilePicUrl,
  });

  factory SearchUser.fromMap(Map<String, dynamic> map) {
    return SearchUser(
        timestamp: map['timestamp'],
        name: map['name'],
        username: map['username'],
        uidUser: map['uidUser'],
        uidSearch: map['uidSearch'],
        profilePicUrl: map['profilePicUrl']);
  }

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'name': name,
      'username': username,
      'uidUser': uidUser,
      'uidSearch': uidSearch,
      'profilePicUrl': profilePicUrl,
    };
  }
}
