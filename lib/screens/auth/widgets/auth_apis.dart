import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_lock/screens/home.dart';

FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;

Future<void> signOut(context) async {
  await firebaseAuth.signOut().then((value) =>
      Navigator.pushNamedAndRemoveUntil(context, "/authScreen", (r) => false));
}

void createUser(userUID, email, context) {
  firestoreInstance.collection("users").doc(userUID).set({
    "name": email,
    "mainLock": "",
    "locks": [],
  }).then((res) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ));
  });
}
