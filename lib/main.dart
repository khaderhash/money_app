import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myappmoney2/Screens/Incomes.dart';
import 'package:myappmoney2/services/firebase_notifications.dart';

import 'Screens/Goals.dart';
import 'Screens/HomePage.dart';
import 'Screens/Goaladd.dart';
import 'Screens/FinancialAnalysis.dart';
import 'Screens/login.dart';
import 'Screens/Expences.dart';
import 'Screens/AddExpences.dart';
import 'Screens/register.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin(); // تهيئة الإشعارات

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirbaseNoticfications().initNotifications();
  runApp(Myapp());
  // تهيئة إشعارات Flutter
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

final GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorkey,
        debugShowCheckedModeBanner: false,
        routes: {
          loginpage.id: (context) => loginpage(),
          registerpage.id: (context) => registerpage(),
          Homepage.id: (context) => Homepage(),
          Goals.id: (context) => Goals(),
          ExpencesScreens.id: (context) => ExpencesScreens(),
          AddExpences.id: (context) => AddExpences(),
          Financialanalysis.id: (context) => Financialanalysis(),
          IncomesScreens.id: (context) => IncomesScreens(),
        },
        initialRoute: loginpage.id);
  }
}
