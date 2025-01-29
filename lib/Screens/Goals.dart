import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import 'GoalEdit.dart';
import 'GoalAdd.dart';

class Goals extends StatefulWidget {
  static String id = "Goals";

  @override
  State<Goals> createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  List<Map<String, dynamic>> listGoal = [];
  final Map<String, GoalData> GOALData = {
    "Education": GoalData(color: Colors.blue, icon: Icon(Icons.school)),
    "Travel": GoalData(color: Colors.orange, icon: Icon(Icons.flight)),
    "Savings": GoalData(color: Colors.green, icon: Icon(Icons.savings)),
    "Others": GoalData(color: Colors.grey, icon: Icon(Icons.more_horiz)),
  };

  @override
  void initState() {
    super.initState();
    loadGoals();
  }

  void saveGoals() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("reminders", json.encode(listGoal));
  }

  Future<void> loadGoals() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString("goals");
    setState(() {
      listGoal = data != null
          ? List<Map<String, dynamic>>.from(json.decode(data))
          : [];
    });
  }

  void updateGoalsList() async {
    await loadGoals();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF264653),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Goals',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: listGoal.isEmpty
          ? const Center(
              child: Text(
                'No goals added yet!',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            )
          : ReorderableListView.builder(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex)
                    newIndex--; // تعديل الفهرس عند التحريك للأسفل
                  final item = listGoal.removeAt(oldIndex);
                  listGoal.insert(newIndex, item);
                });
                saveGoals(); // تحديث SharedPreferences بعد إعادة الترتيب
              },
              itemCount: listGoal.length,
              itemBuilder: (context, index) {
                final goal = listGoal[index];
                final type = goal['type'];
                final name = goal['name'];

                final expenseInfo = GOALData[type];
                final double totalAmount =
                    (goal['totalAmount'] as num).toDouble();
                final double savedAmount =
                    (goal['savedAmount'] as num).toDouble();
                final progress =
                    (totalAmount > 0) ? (savedAmount / totalAmount) : 0.0;

                return Card(
                  key: ValueKey(goal), // مفتاح لتعريف العنصر في القائمة

                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: expenseInfo?.color?.withOpacity(0.2) ??
                            Colors.grey.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: expenseInfo?.icon ??
                          const Icon(Icons.error, color: Colors.grey),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saved: ${currencyFormat.format(savedAmount)} / ${currencyFormat.format(totalAmount)}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: const Color(0xFFE5E5EA),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF0A84FF)),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Color(0xFF264653)),
                      onPressed: () => deleteGoal(index),
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                            builder: (context) =>
                                EditGoalScreen(goalIndex: index),
                          ))
                          .then((_) => updateGoalsList());
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                builder: (context) => AddGoalScreen(
                  onGoalAdded: updateGoalsList,
                ),
              ))
              .then((_) => updateGoalsList());
        },
        tooltip: 'Add Goal',
        backgroundColor: const Color(0xFF0A84FF),
        child: const Icon(Icons.add),
      ),
    );
  }

  void deleteGoal(int index) async {
    setState(() {
      listGoal.removeAt(index);
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("goals", json.encode(listGoal));
  }
}

class GoalData {
  final Color color;
  final Icon icon;

  GoalData({required this.color, required this.icon});
}
