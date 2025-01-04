import 'package:flutter/material.dart';

class OutSideCustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..cubicTo(0, 0, size.width * .1, size.height * .02, size.width * .25,
          size.height * .4)
      ..cubicTo(size.width * .25, size.height * .4, size.width * .5,
          size.height, size.width * .75, size.height * .4)
      ..cubicTo(size.width * .75, size.height * .4, size.width * .85,
          size.height * .02, size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
