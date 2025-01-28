import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

class FirbaseNoticfications {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    // طلب الإذن للإشعارات
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      sound: true,
    );

    print('Permission granted: ${settings.authorizationStatus}');

    // الحصول على الـ token
    String? token = await firebaseMessaging.getToken();
    print("Device Token: $token");

    // التعامل مع الإشعارات أثناء المقدمة
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message.notification!);
    });

    // التعامل مع الإشعارات عند فتح التطبيق من الإشعار
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('تم فتح التطبيق من الإشعار: ${message.notification?.title}');
    });
  }

  void _showNotification(RemoteNotification notification) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'goal_channel_id',
      'Goal Notifications',
      channelDescription: 'Channel for goal-related notifications.',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      notificationDetails,
    );
  }
}
