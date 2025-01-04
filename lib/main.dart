import 'package:flutter/material.dart';
import 'Screens/Expenses.dart';
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
  runApp(const Myapp());
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
          Expenses.id: (context) => Expenses(),
        },
        initialRoute: Homepage.id);
  }
}
