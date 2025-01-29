import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'Screens/AddExpences.dart';
import 'Screens/Expences.dart';
import 'Screens/FinancialAnalysis.dart';
import 'Screens/Goals.dart';
import 'Screens/Incomes.dart';
import 'Screens/Reminders.dart';
import 'Screens/Splashscreen.dart';
import 'Screens/login.dart';
import 'Screens/register.dart';
import 'services/firebase_notifications.dart';

import 'Screens/HomePage.dart';
import 'firebase_options.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // يجب تسجيل هذا الـ handler في main.dart
  await Firebase.initializeApp(); // تأكد من تهيئة Firebase
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'goal_channel_id',
    'Goal Notifications',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.notification?.title ?? 'No Title',
    message.notification?.body ?? 'No Body',
    notificationDetails,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // تسجيل الـ background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // تهيئة الإشعارات
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Notifications App',
      routes: {
        loginpage.id: (context) => loginpage(),
        registerpage.id: (context) => registerpage(),
        Homepage.id: (context) => Homepage(),
        Goals.id: (context) => Goals(),
        ExpencesScreens.id: (context) => ExpencesScreens(),
        AddExpences.id: (context) => AddExpences(),
        Financialanalysis.id: (context) => Financialanalysis(),
        IncomesScreens.id: (context) => IncomesScreens(),
        Reminders.id: (context) => Reminders(),
      },
      home: Splashscreen(),
    );
  }
}
