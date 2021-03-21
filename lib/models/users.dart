import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String mainLock;
  final List locks;
  final DocumentReference reference;

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['mainLock'] != null),
        assert(map['locks'] != null),
        name = map['name'],
        mainLock = map['mainLock'],
        locks = map['locks'];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "User name: $name";
}
