import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  final String id;
  final String name;
  final String username;
  final String email;
  final String? profilePicUrl;
  final String bio;
  final Timestamp lastSeen;
  final bool online;

  Person({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.profilePicUrl,
    this.bio = 'Hello there I\'m a new user',
    required this.lastSeen,
    this.online = false,
  });

  Person.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        username = json['username'],
        email = json['email'],
        profilePicUrl = json['profilePicUrl'],
        bio = json['bio'],
        lastSeen = json['lastSeen'],
        online = json['online'];

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
