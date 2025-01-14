import 'package:flutter/material.dart';
import 'package:myappmoney2/Screens/addnumbertochart1.dart';

import 'Screens/Goals.dart';
import 'Screens/HomePage.dart';
import 'Screens/addtodo.dart';
import 'Screens/expensesmoney.dart';
import 'Screens/login.dart';
import 'Screens/number.dart';
import 'Screens/numberadd.dart';
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
          Goalsadd.id: (context) => Goalsadd(),
          NumberScreen.id: (context) => NumberScreen(),
          addnumber.id: (context) => addnumber(),
          Expencesmoney.id: (context) => Expencesmoney(),
          AddNumberToChart.id: (context) => AddNumberToChart(),
          Goals.id: (context) => Goals(),
        },
        initialRoute: Homepage.id);
  }
}
