import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:smart_lock/apis/queries.dart';
import 'package:smart_lock/models/users.dart';
import './widgets/profile_image.dart';
import '../dialogs/profiles_dialogs.dart';

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
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getUserData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              User user = User.fromSnapshot(snapshot.data);
              return Container(
                height: 630,
                child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  scrollDirection: Axis.vertical,
                  itemCount: user.profiles.length,
                  //shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ProfileImage(
                        imageUrl: user.profiles[index],
                        name: getNameFromUrl(user.profiles[index]));
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                ),
              );
            }
            return Container();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.black,
        onPressed: () {
          // Respond to button press
          addProfile(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

String getNameFromUrl(String url) {
  int startName = url.indexOf('2F') + 2;
  int endName = url.indexOf('?');
  return url.substring(startName, endName);
}
