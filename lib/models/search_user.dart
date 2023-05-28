import 'package:cloud_firestore/cloud_firestore.dart';

/// The class representing a search result for a user.
///
/// A search result contains information such as the user's name, username,
/// user ID, search target ID, profile picture URL, and timestamp.
class SearchUser {
  final String name;
  final String username;
  final String uidUser;
  final String uidSearch;
  final String? profilePicUrl;
  final Timestamp timestamp;

  /// Constructs a [SearchUser] object.
  ///
  /// The [timestamp] is the timestamp when the search result was clicked.
  /// The [name] is the name of the user.
  /// The [username] is the username of the user.
  /// The [uidUser] is the ID of the currently logged-in user.
  /// The [uidSearch] is the ID of the user being searched for.
  /// The [profilePicUrl] is the URL of the user's profile picture (optional).
  SearchUser({
    required this.timestamp,
    required this.name,
    required this.username,
    required this.uidUser,
    required this.uidSearch,
    this.profilePicUrl,
  });

  /// Constructs a [SearchUser] object from a map (JSON) representation.
  ///
  /// The [map] is a JSON object representing the search result.
  factory SearchUser.fromMap(Map<String, dynamic> map) {
    return SearchUser(
      timestamp: map['timestamp'],
      name: map['name'],
      username: map['username'],
      uidUser: map['uidUser'],
      uidSearch: map['uidSearch'],
      profilePicUrl: map['profilePicUrl'],
    );
  }

  /// Converts the [SearchUser] object to a map (JSON) representation.
  ///
  /// Returns a map representing the search result.
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
