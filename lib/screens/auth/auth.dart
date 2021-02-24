import 'package:flutter/material.dart';
import 'package:smart_lock/screens/auth/widgets/sign_in.dart';
import 'package:smart_lock/screens/auth/widgets/sign_up.dart';
import 'package:smart_lock/screens/auth/widgets/background_painter.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  ValueNotifier<bool> showSignInPage = ValueNotifier<bool>(true);

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: CustomPaint(
              painter: BackgroundPainter(
                animation: _controller.view,
              ),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 800),
              child: ValueListenableBuilder<bool>(
                valueListenable: showSignInPage,
                builder: (context, value, child) {
                  return value
                      ? SignIn(
                          onSignInClicked: () {
                            showSignInPage.value = false;
                            _controller.forward();
                          },
                        )
                      : SignUp(
                          onSignUpClicked: () {
                            showSignInPage.value = true;
                            _controller.reverse();
                          },
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
