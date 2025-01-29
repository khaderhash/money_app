import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:myappmoney2/Screens/HomePage.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});
  static final id = "splashscreen";

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        duration: 100000000000,
        backgroundColor: Colors.white,
        splash: Column(
          children: [
            Stack(
              children: [
                Lottie.asset('assets/animation/Animation - 1738153918731.json'),
                Image.asset('assets/photo/khaderlogo.png', height: 150),
              ],
            )
          ],
        ),
        nextScreen: Homepage());
  }
}
