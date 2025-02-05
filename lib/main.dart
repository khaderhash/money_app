import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:myappmoney2/view/AddExpences.dart';
import 'package:myappmoney2/view/AddIncomes.dart';
import 'package:myappmoney2/view/Expences.dart';
import 'package:myappmoney2/view/GoalEdit.dart';
import 'package:myappmoney2/view/Goals.dart';
import 'package:myappmoney2/view/HomePage.dart';
import 'package:myappmoney2/view/Incomes.dart';
import 'package:myappmoney2/view/Reminders.dart';
import 'package:myappmoney2/view/login.dart';
import 'package:myappmoney2/view/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
SharedPreferences? shared;
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

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      getPages: [
        GetPage(
          name: ("/"),
          page: () => loginpage(),
        ),
        GetPage(
          name: ("/RegisterPage"),
          page: () => registerpage(),
        ),
        GetPage(
          name: ("/HomePage"),
          page: () => Homepage(),
        ),
        GetPage(
          name: ("/ExpencesPage"),
          page: () => ExpencesScreens(),
        ),
        GetPage(
          name: ("/IncomesPage"),
          page: () => IncomesScreens(),
        ),
        GetPage(
          name: ("/ReminderPage"),
          page: () => Reminders(),
        ),
        GetPage(
          name: ("/GoalPage"),
          page: () => Goals(),
        ),
        GetPage(
          name: ("/GoalEditPage"),
          page: () => EditGoalScreen(
            goalIndex: 1,
          ),
        ),
        // GetPage(
        //   name: ("/GoalAddPage"),
        //   page: () => AddGoalScreen(
        //     onGoalAdded: () {},
        //   ),
        // ),
        GetPage(
          name: ("/ExpencesEditPage"),
          page: () => AddExpences(),
        ),
        GetPage(
          name: ("/IncomesPage"),
          page: () => AddIncomes(),
        ),
      ],
      initialRoute: "/HomePage",
    );
  }
}
