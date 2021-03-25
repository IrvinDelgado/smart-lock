import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_lock/screens/home.dart';
import 'package:smart_lock/config/palette.dart';
import 'package:smart_lock/screens/auth/widgets/title.dart';
import 'package:smart_lock/screens/auth/widgets/sign_in_up_bar.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key, @required this.onSignInClicked}) : super(key: key);
  final VoidCallback onSignInClicked;
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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

  void loginToFireBase() {
    firebaseAuth
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((result) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(),
          ));
    }).catchError((err) {
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
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    });
    setState(() {
      isSubmitting = false;
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
                    title: "Welcome\nBack",
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Enter Email...",
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
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: "Enter a Password...",
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
                    SignInBar(
                      isLoading: isSubmitting,
                      label: 'Sign in',
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            isSubmitting = true;
                          });
                          loginToFireBase();
                        }
                        print('Validated');
                      },
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        splashColor: Colors.white,
                        onTap: () {
                          this.widget.onSignInClicked?.call();
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
