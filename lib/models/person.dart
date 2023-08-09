import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
  final String? token;

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
    this.token,
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
        online = json['online'],
        token = json['token'];

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
        'token': token,
      };

  String formatLastSeen(Timestamp currentTime) {
    final time = lastSeen.toDate();
    final currentDateTime = currentTime.toDate();
    final difference = currentDateTime.difference(time);

    if (difference.inHours >= 48 || (currentDateTime.day - time.day >= 2)) {
      final formatter = DateFormat('MMM dd, yyyy');
      return 'Last seen ${formatter.format(time)}';
    } else if (difference.inHours >= 24) {
      final formatter = DateFormat("h:mm a");
      return 'Yesterday at ${formatter.format(time)}';
    } else if (difference.inHours >= 1) {
      return 'Last seen ${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes >= 1) {
      return 'Last seen ${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Last seen just now';
    }
  }
}
