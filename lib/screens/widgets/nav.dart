import 'package:flutter/material.dart';
import 'package:smart_lock/screens/auth/widgets/auth_apis.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.blur_circular),
            title: Text('KeyPad'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Camera'),
            onTap: () => {},
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
    );
  }
}
