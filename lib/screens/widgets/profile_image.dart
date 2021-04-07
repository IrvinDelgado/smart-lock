import 'package:flutter/material.dart';
import '../../dialogs/profiles_dialogs.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    Key key,
    @required this.imageUrl,
    @required this.name,
  }) : super(key: key);

  final String imageUrl;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 290,
      width: 300,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 8.0,
        child: Column(
          children: [
            Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
            Container(
              height: 15,
              child: ListTile(
                title: new Text(name),
              ),
            ),
            ButtonBar(
              buttonMinWidth: 10,
              children: [
                TextButton(
                  style: TextButton.styleFrom(primary: Colors.red),
                  onPressed: () {
                    deleteProfiles(context, name);
                  },
                  child: const Icon(Icons.delete),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
