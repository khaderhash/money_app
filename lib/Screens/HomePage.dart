import 'package:flutter/material.dart';
import 'package:myappmoney2/Screens/Goals.dart';
import 'package:myappmoney2/compo/drawer.dart';
import 'package:myappmoney2/constants.dart';
import '../compo/clickHomepage.dart';
import '../compo/outsidecs.dart';
import 'package:myappmoney2/Screens/Expences.dart';
import 'Incomes.dart';
import 'FinancialAnalysis.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Reminders.dart';
import 'login.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  static String id = "homepage";

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn');

    if (isLoggedIn == false || isLoggedIn == null) {
      Navigator.pushReplacementNamed(context, loginpage.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerClass(
        accountName: 'khader',
        accountEmail: 'khader@gmail',
        accountInitial: 'ksfh',
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;

          final screenWidth = constraints.maxWidth;

          return Stack(
            children: [
              Positioned.fill(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(color: Color(0xFFF5F5F5)),
                    ),
                  ],
                ),
              ),
              // Curved Divider (Modified to Half Circle)
              Positioned(
                top: 0,
                child: Container(
                  width: screenWidth,
                  alignment: Alignment.center,
                  child: ClipPath(
                    clipper: OutSideCustomShape(),
                    child: Container(
                      width: screenWidth,
                      height: screenHeight * 0.44,
                      color: Color(0xFFffcc00),
                    ),
                  ),
                ),
              ),
              // Rotated Logo
              Positioned(
                top: screenHeight * 0.1,
                left: screenWidth * 0.17,
                child: Transform.rotate(
                  angle: 0,
                  child: Container(
                    height: hight(context) * .2,
                    width: screenWidth * 0.7,
                    child: Image.asset(
                      'assets/photo/khaderlogo2.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: screenWidth,
                  height: screenHeight * 0.56,
                  color: Color(0xFFF5F5F5),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36.0),
                    child: ListView(
                      children: [
                        SizedBox(height: 20),
                        ButtonHome(
                          ontap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => IncomesScreens()));
                          },
                          name: 'Incomes',
                        ),
                        const SizedBox(height: 8),
                        ButtonHome(
                          ontap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ExpencesScreens()));
                          },
                          name: 'Expences',
                        ),
                        const SizedBox(height: 8),
                        ButtonHome(
                          ontap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Goals()));
                          },
                          name: 'Goals',
                        ),
                        const SizedBox(height: 8),
                        ButtonHome(
                          ontap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Reminders()));
                          },
                          name: 'Reminders',
                        ),
                        const SizedBox(height: 8),
                        ButtonHome(
                          ontap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Financialanalysis()));
                          },
                          name: 'Analysis money',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
