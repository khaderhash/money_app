import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:myappmoney2/main.dart';

import '../Screens/GoalEdit.dart';

class FirbaseNoticfications {
  final Firebasemessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await Firebasemessaging.requestPermission();
    String? token = await Firebasemessaging.getToken();
    print("token : $token");
    handleBacknotificaon();
  }

  void handlemessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorkey.currentState!.pushNamed(EditGoalScreen.id, arguments: message);
  }

  Future handleBacknotificaon() async {
    FirebaseMessaging.instance.getInitialMessage().then(handlemessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handlemessage);
  }
}
