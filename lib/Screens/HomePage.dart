import 'package:flutter/material.dart';
import 'package:myappmoney2/Screens/Goals.dart';
import 'package:myappmoney2/compo/drawer.dart';
import '../compo/clickHomepage.dart';
import '../compo/outsidecs.dart';
import 'package:myappmoney2/Screens/Expences.dart';
import 'addnumbertochart1.dart';
import 'FinancialAnalysis.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});
  static String id = "homepage";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                // Background Color
                Positioned.fill(
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                            color: Color(0xFFF5F5F5)), // خلفية رمادية فاتحة
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
                      clipper: OutSideCustomShape(), // تطبيق الشكل نصف الدائرة
                      child: Container(
                        width: screenWidth,
                        height: screenHeight * 0.44,
                        color: Color(0xFF264653), // الأزرق الداكن
                      ),
                    ),
                  ),
                ),

                // Rotated Logo
                Positioned(
                  top: screenHeight * 0.1,
                  left: screenWidth * 0.25,
                  child: Transform.rotate(
                    angle: -0.2,
                    child: SizedBox(
                      width: screenWidth * 0.47,
                      child: Image.asset(
                        'assets/photo/khaderlogo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                // Buttons Section
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: screenWidth,
                    height: screenHeight * 0.56,
                    color: Color(0xFFF5F5F5), // خلفية رمادية فاتحة
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
                                      builder: (context) =>
                                          AddNumberToChart()));
                            },
                            name: 'المفروض المصارف',
                          ),
                          const SizedBox(height: 8),
                          ButtonHome(
                            ontap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ExpencesScreens()));
                            },
                            name: 'المفروض المداخيل',
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
      ),
    );
  }
}
