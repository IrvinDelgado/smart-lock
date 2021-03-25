import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;
FirebaseStorage firebaseStorage = FirebaseStorage.instance;
String userUid = firebaseAuth.currentUser.uid;

Future<DocumentSnapshot> getLockData() async {
  DocumentSnapshot lockData =
      await firestoreInstance.collection("locks").doc("front-door").get();
  return lockData;
}

Future<DocumentSnapshot> getUserData() async {
  DocumentSnapshot userData =
      await firestoreInstance.collection("users").doc(userUid).get();
  return userData;
}

void updateLockKeypad(String newKeypad) {
  firestoreInstance
      .collection("locks")
      .doc("front-door")
      .update({"keypad": newKeypad});
}

void uploadImage(File imageFile, String profileName) async {
  await firebaseStorage.ref().child('uploads/$profileName').putFile(imageFile);
  String url = await firebaseStorage
      .ref()
      .child('uploads/$profileName')
      .getDownloadURL();
  await firestoreInstance.collection("users").doc(userUid).update({
    "profiles": FieldValue.arrayUnion([url])
  });
}
