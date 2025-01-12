import 'package:flutter/material.dart';
import 'package:myappmoney2/Screens/Goals.dart';
import 'package:myappmoney2/compo/drawer.dart';

import '../compo/clickHomepage.dart';
import '../compo/outsidecs.dart';
import '../constants.dart';
import 'expensesmoney.dart';
import 'number.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});
  static String id = "homepage";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: drawerclass(),
        body: SizedBox(
          width: width(context),
          height: hight(context),
          child: Stack(children: [
            SizedBox(
              width: width(context),
              height: hight(context) * .4,
              child: Image.asset(
                'assets/photo/color1.jpg',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: width(context),
              height: hight(context) * .2,
              child: Transform.rotate(
                angle: -.3,
                child: Image.asset(
                  'assets/photo/khaderlogo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
                top: hight(context) * .341,
                child: Container(
                  alignment: Alignment.center,
                  width: width(context),
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: ClipPath(
                      clipper: OutSideCustomShape(),
                      child: Container(
                        width: width(context) * .5,
                        height: hight(context) * .06,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )),
            Positioned(
                bottom: 0,
                child: Container(
                  width: width(context),
                  height: hight(context) * .5,
                  color: Colors.white,
                  child: Column(children: [
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: width(context) * .1,
                        ),
                        ButtonHome(
                          ontap: () {
                            Navigator.pushNamed(context, Goals.id);
                          },
                          name: 'Expenc',
                        ),
                        SizedBox(
                          width: width(context) * .2,
                        ),
                        ButtonHome(
                          ontap: () {},
                          name: '',
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 55,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: width(context) * .1,
                        ),
                        ButtonHome(
                          ontap: () {
                            Navigator.pushNamed(context, NumberScreen.id );
                          },
                          name: 'expensemoney',
                        ),
                        SizedBox(
                          width: width(context) * .2,
                        ),
                        ButtonHome(
                          ontap: () {
                            Navigator.pushNamed(context, Expencesmoney.id);
                          },
                          name: 'Expencesmoney',
                        ),
                      ],
                    )
                  ]),
                ))
          ]),
        ),
      ),
    );
  }
}
