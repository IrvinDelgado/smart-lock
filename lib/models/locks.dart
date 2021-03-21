import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String title;
  final int status;
  final int keypad;
  final DocumentReference reference;

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['status'] != null),
        assert(map['keypad'] != null),
        title = map['title'],
        status = map['status'],
        keypad = map['keypad'];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Lock Name: $title";
}
