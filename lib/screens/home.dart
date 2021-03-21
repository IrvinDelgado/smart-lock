import 'package:flutter/material.dart';
import 'package:smart_lock/apis/streams.dart';
import 'package:smart_lock/screens/widgets/keypad.dart';
import 'package:smart_lock/screens/widgets/nav.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLocked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text("Smart Lock"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Container(
              height: 50,
            ),
            lockData(context),
            Container(
              height: 50,
            ),
            Container(
              child: KeyPad(),
            ),
          ],
        ),
      ),
    );
  }
}
