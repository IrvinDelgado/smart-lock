import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_lock/apis/queries.dart';

Future addProfile(context) {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: new Text("Create Profile"),
        clipBehavior: Clip.none,
        scrollable: true,
        content: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Enter Profile Name",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Profile Name';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          new TextButton(
            child: new Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: ElevatedButton(
              //color: Colors.lightGreen,
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  print(nameController.text);
                  final picker = ImagePicker();
                  final pickedFile =
                      await picker.getImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    print(File(pickedFile.path));
                    uploadImage(File(pickedFile.path), nameController.text);
                  } else {
                    print('No image selected.');
                  }
                }
              },
              child: Text('Add Image'),
            ),
          ),
        ],
      );
    },
  );
}

Future deleteProfiles(context, name) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: new Text("Delete Profile"),
        clipBehavior: Clip.none,
        scrollable: true,
        content: Center(
          child: Text("Are you sure you want to delete the profile?"),
        ),
        actions: [
          new TextButton(
            child: new Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.redAccent),
              ),
              onPressed: () {
                deleteImage(name);
              },
              child: Text('Delete'),
            ),
          ),
        ],
      );
    },
  );
}
