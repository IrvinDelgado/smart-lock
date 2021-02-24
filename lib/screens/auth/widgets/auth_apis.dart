import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;

Future<void> signOut(context) async {
  await firebaseAuth.signOut().then((value) =>
      Navigator.pushNamedAndRemoveUntil(context, "/authScreen", (r) => false));
}
