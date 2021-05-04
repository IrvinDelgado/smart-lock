import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_lock/apis/queries.dart';
import 'package:smart_lock/models/locks.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera"),
      ),
      body: Container(
        child: Column(
          children: [lockImage(), getImageFromlock()],
        ),
      ),
    );
  }

  Widget lockImage() {
    return FutureBuilder(
        future: getLockData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            Lock lock = Lock.fromSnapshot(snapshot.data);
            if (lock.imageUrl == "") {
              return Container(
                child: Image(
                  image: AssetImage('assets/images/test.jpg'),
                ),
              );
            } else {
              return Container(child: Image.network(lock.imageUrl));
            }
          }
          return CircularProgressIndicator();
        });
  }

  // Container(
  //       child: Image(image: AssetImage('assets/images/test.jpg')),
  //     );
  Widget getImageFromlock() {
    return Container(
      child: ElevatedButton(
        onPressed: () {
          //change TakingPhoto to 1
          queueTakePhoto();
          sleep(Duration(milliseconds: 500));
          setState(() {});
        },
        child: Text("GET IMAGE"),
      ),
    );
  }
}
