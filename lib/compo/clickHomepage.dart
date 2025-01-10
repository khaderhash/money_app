import 'package:flutter/material.dart';

import '../Screens/Goals.dart';
import '../constants.dart';

class ButtonHome extends StatelessWidget {
  ButtonHome({super.key, required this.ontap, required this.name});
  VoidCallback? ontap;
  String? name;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        child: Center(
          child: Text(name!),
        ),
        decoration: BoxDecoration(
            border: Border.symmetric(
                vertical: BorderSide(
                  color: Colors.yellow,
                  width: 6,
                ),
                horizontal: BorderSide(color: Colors.yellow, width: 6))),
        width: width(context) * .3,
        height: hight(context) * .13,
      ),
    );
  }
}
