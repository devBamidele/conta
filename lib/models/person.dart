import 'package:cloud_firestore/cloud_firestore.dart';

/// The class representing a person.
///
/// A person contains information such as their ID, name, username, email,
/// profile picture URL, bio, last seen timestamp, and online status.
class Person {
  final String id;
  final String name;
  final String username;
  final String email;
  final String? profilePicUrl;
  final String bio;
  final Timestamp lastSeen;
  final bool online;

  /// Constructs a [Person] object.
  ///
  /// The [id] is the unique identifier of the person.
  /// The [name] is the name of the person.
  /// The [username] is the username of the person.
  /// The [email] is the email address of the person.
  /// The [profilePicUrl] is the URL of the person's profile picture (optional).
  /// The [bio] is the biography or description of the person.
  /// The [lastSeen] is the timestamp when the person was last seen.
  /// The [online] indicates whether the person is currently online.
  Person({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.profilePicUrl,
    this.bio = 'Hello there, I\'m a new user.',
    required this.lastSeen,
    this.online = false,
  });

  /// Deserialize the JSON data received from Firestore into a [Person] object.
  ///
  /// The [json] is a JSON object representing the person's data.
  Person.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        username = json['username'],
        email = json['email'],
        profilePicUrl = json['profilePicUrl'],
        bio = json['bio'],
        lastSeen = json['lastSeen'],
        online = json['online'];

  /// Serialize the [Person] object into a JSON object for storage in Firestore.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'username': username,
        'email': email,
        'profilePicUrl': profilePicUrl,
        'bio': bio,
        'lastSeen': lastSeen,
        'online': online,
      };
}
