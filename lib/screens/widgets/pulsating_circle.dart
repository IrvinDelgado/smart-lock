import 'package:flutter/material.dart';

class PulsatingCircleIconButton extends StatefulWidget {
  const PulsatingCircleIconButton({
    Key key,
    @required this.onTap,
    @required this.icon,
    @required this.backgroundColor,
  }) : super(key: key);

  final GestureTapCallback onTap;
  final Icon icon;
  final Color backgroundColor;

  @override
  _PulsatingCircleIconButtonState createState() =>
      _PulsatingCircleIconButtonState();
}

class _PulsatingCircleIconButtonState extends State<PulsatingCircleIconButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = Tween(begin: 0.0, end: 12.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          return Ink(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              shape: BoxShape.circle,
              boxShadow: [
                for (int i = 1; i <= 2; i++)
                  BoxShadow(
                    color: widget.backgroundColor
                        .withOpacity(_animationController.value / 2),
                    spreadRadius: _animation.value * i,
                  )
              ],
            ),
            child: widget.icon,
          );
        },
      ),
    );
  }
}
