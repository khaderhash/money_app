import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../compo/AppBarcom.dart';

class EditGoalScreen extends StatefulWidget {
  final int goalIndex;
  static String id = "EditGoalScreen";

  const EditGoalScreen({Key? key, required this.goalIndex}) : super(key: key);

  @override
  _EditGoalScreenState createState() => _EditGoalScreenState();
}

class _EditGoalScreenState extends State<EditGoalScreen> {
  Map<String, dynamic>? goal;
  final TextEditingController newAmountController = TextEditingController();
  Timer? timer;
  Duration? timeLeft;
  Duration totalDuration = const Duration();
  bool halfTimeNotified = false;
  bool goalCompletedNotified = false;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'goal_channel_id',
      'Goal Notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'goal_notification',
    );
  }

  Future<void> loadGoal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString("goals");
    if (data != null) {
      final List goals = json.decode(data);
      setState(() {
        goal = goals[widget.goalIndex];
        updateTimeLeft();
        startCountdown();
      });
    }
  }

  void updateTimeLeft() {
    if (goal?['deadline'] != null) {
      final deadline = DateTime.parse(goal!['deadline']);
      final now = DateTime.now();
      setState(() {
        timeLeft = deadline.difference(now);
        totalDuration = deadline
            .difference(DateTime.parse(goal!['startDate'] ?? now.toString()));
      });

      // Check if half time has passed
      if (timeLeft!.inSeconds <= totalDuration.inSeconds / 2 &&
          !halfTimeNotified) {
        showNotification(
            "Half Time Passed", "Half of the time for your goal has passed!");
        setState(() {
          halfTimeNotified = true;
        });
      }

      // Check if time is up
      if (timeLeft!.inSeconds <= 0) {
        showNotification(
            "Time's Up!", "The deadline for your goal has passed.");
        timer?.cancel();
      }
    }
  }

  void startCountdown() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      updateTimeLeft();
    });
  }

  Future<void> updateGoal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString("goals");
    if (data != null) {
      final List goals = json.decode(data);
      if (widget.goalIndex >= 0 && widget.goalIndex < goals.length) {
        final updatedGoal = Map<String, dynamic>.from(goals[widget.goalIndex]);
        updatedGoal["savedAmount"] +=
            double.tryParse(newAmountController.text) ?? 0;

        if (updatedGoal["savedAmount"] >= updatedGoal["totalAmount"] &&
            !goalCompletedNotified) {
          updatedGoal["savedAmount"] = updatedGoal["totalAmount"];
          showNotification("Goal Completed!",
              "Congratulations! You have reached your goal.");
          setState(() {
            goalCompletedNotified = true;
          });
        }

        goals[widget.goalIndex] = updatedGoal;
        await prefs.setString("goals", json.encode(goals));
        Navigator.pop(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    loadGoal();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (goal == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Loading...")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final double totalAmount = (goal!["totalAmount"] as num).toDouble();
    final double savedAmount = (goal!["savedAmount"] as num).toDouble();
    final double percentage =
        (totalAmount > 0) ? (savedAmount / totalAmount) : 0.0;

    double timePercentage = 0.0;
    if (totalDuration.inSeconds > 0 && timeLeft != null) {
      timePercentage =
          (timeLeft!.inSeconds / totalDuration.inSeconds).clamp(0.0, 1.0);
    }

    return Scaffold(
      appBar: Appbarofpage(TextPage: "Goal Edit"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Goal: ${goal!["name"]}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF482F37),
              ),
            ),
            const SizedBox(height: 64),
            Center(
              child: SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: percentage * 100,
                        color: Colors.blue,
                        title: "${(percentage * 100).toStringAsFixed(1)}%",
                        radius: 60,
                        titleStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      PieChartSectionData(
                        value: (1 - percentage) * 100,
                        color: Colors.grey[300],
                        title: "",
                        radius: 60,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Saved: ${savedAmount.toStringAsFixed(2)} / ${totalAmount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            if (timeLeft != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: timePercentage,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation(
                        timePercentage > 0.5 ? Colors.green : Colors.red),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Time Remaining: ${timeLeft!.inDays} days, ${(timeLeft!.inHours % 24).toString().padLeft(2, '0')}:${(timeLeft!.inMinutes % 60).toString().padLeft(2, '0')}:${(timeLeft!.inSeconds % 60).toString().padLeft(2, '0')}",
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            const SizedBox(height: 16),
            TextField(
              controller: newAmountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Add New Amount",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: updateGoal,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  "Update Goal",
                  style: TextStyle(
                    color: const Color(0xFF482F37),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
