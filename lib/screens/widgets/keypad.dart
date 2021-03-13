import 'package:flutter/material.dart';

class KeyPad extends StatefulWidget {
  @override
  _KeyPadState createState() => _KeyPadState();
}

class _KeyPadState extends State<KeyPad> {
  Future _changeKeyDialogue(context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController numberController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: new Text("Changing KeyPad"),
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
                      controller: numberController,
                      decoration: InputDecoration(
                        labelText: "Enter New KeyPad",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter KeyPad';
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
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: RaisedButton(
                color: Colors.lightGreen,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    print(numberController.text);
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            //Widget Displaying KeyNumber
            Container(
              child: Text(
                "12315",
                style: TextStyle(
                  fontSize: 62,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              height: 30,
            ),
            //Button to Change Widget
            RaisedButton(
              onPressed: () {
                _changeKeyDialogue(context);
              },
              child: Text("Change KeyPad"),
            )
          ],
        ),
      ),
    );
  }
}
