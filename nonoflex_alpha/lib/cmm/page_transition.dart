import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Custom extends CustomTransition {

  final Widget enterPage;
  final Widget exitPage;


  Custom(this.enterPage, this.exitPage);

  @override
  Widget buildTransition(BuildContext context, Curve? curve, Alignment? alignment,
      Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {

    return  Stack(
      children: <Widget>[
        SlideTransition(
          position: new Tween<Offset>(
            begin: const Offset(0.0, 0.0),
            end: const Offset(-1.0, 0.0),
          ).animate(animation),
          child: exitPage,
        ),
        SlideTransition(
          position: new Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: enterPage,
        )
      ],
    );
  }
}