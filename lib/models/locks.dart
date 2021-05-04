import 'package:cloud_firestore/cloud_firestore.dart';

class Lock {
  final String title;
  final int status;
  final int takingPhoto;
  final String keypad;
  final String imageUrl;
  final DocumentReference reference;

  Lock.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['status'] != null),
        assert(map['keypad'] != null),
        assert(map['imageUrl'] != null),
        assert(map['takingPhoto'] != null),
        title = map['title'],
        status = map['status'],
        takingPhoto = map['takingPhoto'],
        keypad = map['keypad'],
        imageUrl = map['imageUrl'];

  Lock.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Lock Name: $title";
}
