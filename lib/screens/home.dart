import 'package:flutter/material.dart';
import 'package:smart_lock/screens/widgets/nav.dart';
import 'package:smart_lock/screens/widgets/pulsating_circle.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLocked = false;

  Widget lockedButton() {
    return Container(
      child: PulsatingCircleIconButton(
        onTap: () {
          setState(() {
            isLocked = false;
          });
        },
        icon: Icon(
          Icons.lock_outline,
          color: Colors.black,
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget unlockedButton() {
    return Container(
      child: PulsatingCircleIconButton(
        onTap: () {
          setState(() {
            isLocked = true;
          });
        },
        icon: Icon(
          Icons.lock_open,
          color: Colors.black,
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

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
        child: isLocked ? lockedButton() : unlockedButton(),
      ),
    );
  }
}
