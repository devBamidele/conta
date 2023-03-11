import 'package:cloud_firestore/cloud_firestore.dart';

/*
Stream<List<SearchChat>> getRecentSearches() {
    return FirebaseFirestore.instance
        .collection('recent_searches')
        .where('uid', isEqualTo: currentUser!.uid)
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => SearchChat.fromMap(doc.data()))
            .toList());
  }

 */
class Person {
  final String id;
  final String name;
  final String username;
  final String email;
  final String? profilePicUrl;
  final String bio;
  final List<String> contactUids;
  final Timestamp lastSeen;
  final bool online;

  Person({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.profilePicUrl,
    this.bio = 'Hello there I\'m a new user',
    required this.contactUids,
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
        contactUids = List<String>.from(json['contactUids'] ?? []),
        lastSeen = json['lastSeen'],
        online = json['online'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'username': username,
        'email': email,
        'profilePicUrl': profilePicUrl,
        'bio': bio,
        'contactUids': contactUids,
        'lastSeen': lastSeen,
        'online': online,
      };
}
