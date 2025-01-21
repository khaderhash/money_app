import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

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
      });
    }
  }

  void startCountdown() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      updateTimeLeft();
      if (timeLeft != null && timeLeft!.inSeconds <= 0) {
        timer?.cancel();
        setState(() {
          timeLeft = const Duration(seconds: 0);
        });
      }
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

        // التحقق من تحقيق الهدف
        if (updatedGoal["savedAmount"] >= updatedGoal["totalAmount"]) {
          updatedGoal["savedAmount"] = updatedGoal["totalAmount"];
          // عرض رسالة التهنئة
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Congratulations!"),
              content: const Text("You have reached your goal!"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
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

    return Scaffold(
      appBar: AppBar(
        // title: Text("${goal!["name"]}"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Goal: ${goal!["name"]}",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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

            // المبلغ المدخر
            Text(
              "Saved: ${savedAmount.toStringAsFixed(2)} / ${totalAmount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),

            // المؤقت
            if (timeLeft != null)
              Text(
                "Time Left: ${timeLeft!.inDays} days, ${(timeLeft!.inHours % 24).toString().padLeft(2, '0')}:${(timeLeft!.inMinutes % 60).toString().padLeft(2, '0')}:${(timeLeft!.inSeconds % 60).toString().padLeft(2, '0')}",
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            const SizedBox(height: 16),

            // حقل إدخال لإضافة مبلغ جديد
            TextField(
              controller: newAmountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Add New Amount",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // زر تحديث الهدف
            Center(
              child: ElevatedButton(
                onPressed: updateGoal,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text("Update Goal"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
