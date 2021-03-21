import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;

Future<DocumentSnapshot> getLockData() async {
  DocumentSnapshot lockData =
      await firestoreInstance.collection("locks").doc("front-door").get();
  return lockData;
}

void updateLockKeypad(String newKeypad) {
  firestoreInstance
      .collection("locks")
      .doc("front-door")
      .update({"keypad": newKeypad});
}
