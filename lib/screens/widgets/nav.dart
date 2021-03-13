import 'package:flutter/material.dart';
import 'package:smart_lock/screens/auth/widgets/auth_apis.dart';
import 'package:smart_lock/screens/camera.dart';
import 'package:smart_lock/screens/profiles.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 175,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 20,
            ),
            ListTile(
              leading: Icon(Icons.group_rounded),
              title: Text('Profiles'),
              onTap: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profiles()))
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Camera'),
              onTap: () => {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Camera()))
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('LogOut'),
              onTap: () async {
                await signOut(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
