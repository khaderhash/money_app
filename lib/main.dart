import 'package:flutter/material.dart';
import 'package:moneyappp/Screens/addtodo.dart';
import 'package:moneyappp/Screens/number.dart';
import 'package:moneyappp/Screens/numberadd.dart';
import 'Screens/Goals.dart';
import 'Screens/HomePage.dart';
import 'Screens/login.dart';
import 'Screens/register.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          loginpage.id: (context) => loginpage(),
          registerpage.id: (context) => registerpage(),
          Homepage.id: (context) => Homepage(),
          Goals.id: (context) => Goals(),
          Goalsadd.id: (context) => Goalsadd(),
          NumberScreen.id: (context) => NumberScreen(),
          addnumber.id: (context) => addnumber(),
        },
        initialRoute: Homepage.id);
  }
}
