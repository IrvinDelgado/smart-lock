import 'package:flutter/material.dart';

class KeyPad extends StatefulWidget {
  @override
  _KeyPadState createState() => _KeyPadState();
}

class _KeyPadState extends State<KeyPad> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("KeyPad"),
      ),
    );
  }
}
