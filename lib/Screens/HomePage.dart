import 'package:flutter/material.dart';
import 'package:moneyappp/Screens/Expenses.dart';

import '../compo/outsidecs.dart';
import '../constants.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});
  static String id = "homepage";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.yellow,
                ), //BoxDecoration
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Colors.green),
                  accountName: Text(
                    "Abhishek Mishra",
                    style: TextStyle(fontSize: 18),
                  ),
                  accountEmail: Text("abhishekm977@gmail.com"),
                  currentAccountPictureSize: Size.square(50),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 165, 255, 137),
                    child: Text(
                      "A",
                      style: TextStyle(fontSize: 30.0, color: Colors.blue),
                    ), //Text
                  ), //circleAvatar
                ), //UserAccountDrawerHeader
              ), //DrawerHeader
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text(' My Profile '),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.book),
                title: const Text(' My Course '),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.workspace_premium),
                title: const Text(' Go Premium '),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.video_label),
                title: const Text(' Saved Videos '),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text(' Edit Profile '),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('LogOut'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
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
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, Expenses.id);
                              },
                              child: Container(
                                child: Center(child: Text("dsj")),
                                decoration: BoxDecoration(
                                    border: Border.symmetric(
                                        vertical: BorderSide(
                                          color: Colors.yellow,
                                          width: 6,
                                        ),
                                        horizontal: BorderSide(
                                            color: Colors.yellow, width: 6))),
                                width: width(context) * .3,
                                height: hight(context) * .13,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: width(context) * .2,
                        ),
                        GestureDetector(
                          child: Container(
                            child: Center(child: Text("dskflj")),
                            decoration: BoxDecoration(
                                border: Border.symmetric(
                                    vertical: BorderSide(
                                      width: 6,
                                    ),
                                    horizontal: BorderSide(width: 6))),
                            width: width(context) * .3,
                            height: hight(context) * .13,
                          ),
                        )
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
                        Stack(
                          children: [
                            GestureDetector(
                              child: Container(
                                child: Center(child: Text("dskflj")),
                                decoration: BoxDecoration(
                                    border: Border.symmetric(
                                        vertical: BorderSide(
                                          width: 6,
                                        ),
                                        horizontal: BorderSide(width: 6))),
                                width: width(context) * .3,
                                height: hight(context) * .13,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: width(context) * .2,
                        ),
                        GestureDetector(
                          child: Container(
                            child: Center(child: Text("dskflj")),
                            decoration: BoxDecoration(
                                border: Border.symmetric(
                                    vertical: BorderSide(
                                      width: 6,
                                    ),
                                    horizontal: BorderSide(width: 6))),
                            width: width(context) * .3,
                            height: hight(context) * .13,
                          ),
                        )
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
