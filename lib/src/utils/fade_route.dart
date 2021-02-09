import 'package:flutter/material.dart';

class FadeRoute<T> extends PageRouteBuilder<T> {
  final Widget widget;

  FadeRoute({@required this.widget})
      : super(
          pageBuilder: (_, animation, secondaryAnimation) => widget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var curve = Curves.ease;

            var tween = Tween(begin: 0.0, end: 1.0);
            var curvedAnimation =
                CurvedAnimation(parent: animation, curve: curve);

            return FadeTransition(
              child: child,
              opacity: tween.animate(curvedAnimation),
            );
          },
        );
}
