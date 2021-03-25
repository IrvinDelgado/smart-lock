import 'package:flutter/material.dart';
import './widgets/profile_image.dart';

class Profiles extends StatefulWidget {
  @override
  _ProfilesState createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profiles"),
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Center(
            child: Column(children: [
              ProfileImage(
                imageUrl: 'https://picsum.photos/250?image=9',
                name: 'Irvin',
              ),
            ]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.black,
        onPressed: () {
          // Respond to button press
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
