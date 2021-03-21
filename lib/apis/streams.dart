import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_lock/models/locks.dart';
import 'package:smart_lock/screens/widgets/pulsating_circle.dart';

FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;

Widget lockData(BuildContext context) {
  return StreamBuilder(
    stream: firestoreInstance.collection("locks").doc("front-door").snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      if (snapshot.hasData) {
        Lock lock = Lock.fromSnapshot(snapshot.data);
        print(lock);
        print('\n${snapshot.data.data()}');
        //set up pulsating circle Icon
        IconData lockIcon;
        Color lockColor;
        if (lock.status == 0) {
          lockIcon = Icons.lock_open;
          lockColor = Colors.green;
        } else {
          lockIcon = Icons.lock_outline;
          lockColor = Colors.red;
        }
        return PulsatingCircleIconButton(
          onTap: () {
            int newStatus = lock.status == 0 ? 1 : 0;
            firestoreInstance
                .collection("locks")
                .doc("front-door")
                .update({"status": newStatus});
          },
          icon: Icon(
            lockIcon,
            color: Colors.black,
          ),
          backgroundColor: lockColor,
        );
      }
      return Container();
    },
  );
}
