import 'package:cloud_firestore/cloud_firestore.dart';

class SearchUser {
  final Timestamp timestamp; // The time the item was clicked
  final String name; // The name of the person that was clicked
  final String uid; // This shows the unique id of the current logged in user

  SearchUser({
    required this.timestamp,
    required this.name,
    required this.uid,
  });

  factory SearchUser.fromMap(Map<String, dynamic> map) {
    return SearchUser(
      timestamp: map['timestamp'],
      name: map['name'],
      uid: map['uid'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'name': name,
      'uid': uid,
    };
  }
}
