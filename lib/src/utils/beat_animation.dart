import 'package:flutter/material.dart';

class BeatAnimation extends StatefulWidget {
  final Widget child;
  final AnimationController controller;

  BeatAnimation({
    Key key,
    @required this.child,
    @required this.controller,
  }) : super(key: key);

  @override
  _BeatAnimationState createState() => _BeatAnimationState();
}

class _BeatAnimationState extends State<BeatAnimation> {
  Animation<double> beat;
  Animation<double> opacity;

  @override
  void initState() {
    super.initState();
    opacity = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: widget.controller, curve: Interval(0, 0.45)));

    beat = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: widget.controller, curve: Curves.elasticOut));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.controller,
        builder: (BuildContext context, Widget child) {
          return Transform.scale(
            scale: beat.value,
            child: Opacity(
              opacity: opacity.value,
              child: widget.child,
            ),
          );
        });
  }
}
