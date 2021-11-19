import 'package:flutter/material.dart';

abstract class AFpageTransisi {
  static Route slide({
    required Widget page,
    required double dx,
    required double dy,
    int milliseconds = 700,
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: Duration(milliseconds: milliseconds),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Offset begin = Offset(dx, dy);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
