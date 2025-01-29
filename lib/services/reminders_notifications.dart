import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class FirebaseNotifications {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('Permission granted: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message.notification!);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('App opened from notification: ${message.notification?.title}');
    });
  }

  void _showNotification(RemoteNotification notification) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString("reminders");

    if (data != null) {
      final List reminders = json.decode(data);
      final reminder = reminders.firstWhere(
          (r) => r['name'] == notification.title,
          orElse: () => null);
      if (reminder != null) {
        const AndroidNotificationDetails androidDetails =
            AndroidNotificationDetails(
          'reminder_channel_id',
          'Reminder Notifications',
          channelDescription: 'Channel for reminder notifications.',
          importance: Importance.high,
          priority: Priority.high,
        );

        const NotificationDetails notificationDetails =
            NotificationDetails(android: androidDetails);

        await flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          'You need to pay ${reminder['amount']} USD for ${reminder['name']}!',
          notificationDetails,
        );
      }
    }
  }
}
