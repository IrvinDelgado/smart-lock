import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:smart_lock/config/palette.dart';

import 'title.dart';
import 'sign_in_up_bar.dart';
import 'auth_apis.dart';

class SignUp extends StatefulWidget {
  SignUp({Key key, @required this.onSignUpClicked}) : super(key: key);
  final VoidCallback onSignUpClicked;
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  bool isSubmitting = false;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void registerToFireBase() {
    firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((result) {
      createUser(result.user.uid, emailController.text, context);
    }).catchError((err) {
      print(err.message);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.message),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/authScreen", (r) => false);
                  },
                ),
              ],
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(34.0),
          child: Column(
            children: [
              Expanded(
                flex: 3, //3/7
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: LoginTitle(
                    title: "Create\nAccount",
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Enter Email...",
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter an Email Address';
                          } else if (!value.contains('@')) {
                            return 'Please Enter a valid email address';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: "Enter a Password...",
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter a password';
                          } else if (value.length < 6) {
                            return 'Password must be greater than 6 Characters!';
                          }
                          return null;
                        },
                      ),
                    ),
                    SignUpBar(
                      isLoading: isSubmitting,
                      label: 'Sign Up',
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            isSubmitting = true;
                          });
                          registerToFireBase();
                        }
                        print('Validated');
                      },
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        splashColor: Colors.white,
                        onTap: () {
                          this.widget.onSignUpClicked?.call();
                        },
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                            color: Palette.darkBlue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
