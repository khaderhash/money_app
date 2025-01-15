import 'package:flutter/material.dart';

class OutSideCustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;




    Path path_1 = Path();
    path_1.moveTo(0,0);
    path_1.lineTo(size.width*1.0006667,0);
    path_1.lineTo(size.width*0.9988833,size.height*0.6428714);
    path_1.quadraticBezierTo(size.width*0.5043833,size.height*0.9995286,size.width*-0.0004500,size.height*0.6429571);
    path_1.quadraticBezierTo(size.width*-0.0004500,size.height*0.4998143,0,0);
    path_1.close();

    return path_1;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
