// Goals.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/Shared_preferences_goal.dart';
import 'Goaladd.dart';
import 'package:intl/intl.dart';

class Goals extends StatefulWidget {
  Goals({super.key});
  static String id = "Goals";

  @override
  State<Goals> createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  List<Map<String, dynamic>> listGoal = [];
  SharedPreferencesServicegoals? servicetoaddtext;
  final Map<String, GoalData> GOALData = {
    "Food & Drinks": GoalData(color: Colors.green, icon: Icon(Icons.fastfood)),
    "Shopping": GoalData(color: Colors.blue, icon: Icon(Icons.shopping_cart)),
    "Housing": GoalData(color: Colors.orange, icon: Icon(Icons.home)),
    "Transportation":
        GoalData(color: Colors.red, icon: Icon(Icons.directions_bus)),
    "Vehicle": GoalData(
        color: Colors.deepPurpleAccent, icon: Icon(Icons.directions_car)),
    "Others": GoalData(color: Colors.grey, icon: Icon(Icons.more_horiz)),
  };

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  initSharedPreferences() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      servicetoaddtext = SharedPreferencesServicegoals(sharedPreferences);
      listGoal = await servicetoaddtext?.getTodo() ?? [];
      setState(() {});
    } catch (e) {
      debugPrint("Error initializing SharedPreferences: $e");
    }
  }

  void updateList() async {
    try {
      listGoal = await servicetoaddtext?.getTodo() ?? [];
      setState(() {});
    } catch (e) {
      debugPrint("Error updating list: $e");
    }
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
          : ListView.builder(
              itemCount: listGoal.length,
              itemBuilder: (context, index) {
                final goal = listGoal[index];
                final type = goal["type"] ?? "Others";
                final value = goal["value"] ?? "No value";
                final expenseInfo = GOALData[type];
                double targetAmount =
                    double.tryParse(goal['amount'] ?? '0') ?? 0;
                double currentAmount =
                    double.tryParse(goal['current_amount'] ?? '0') ?? 0;
                double progress =
                    (targetAmount > 0) ? (currentAmount / targetAmount) : 0;

                return Card(
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text(
                      type,
                      style: const TextStyle(
                        fontSize: 24,
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
                        const SizedBox(height: 5),
                        Text(
                          value,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: const Color(0xFFE5E5EA),
                          valueColor: AlwaysStoppedAnimation<Color>(
                              const Color(0xFF0A84FF)),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Color(0xFF264653)),
                      onPressed: () => deleteItem(index),
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                        builder: (context) => GoalsaddEdit(
                          title: goal['goal'],
                          index: index,
                        ),
                      ))
                          .then((_) {
                        updateList();
                      });
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (context) => GoalsaddEdit(title: ''),
          ))
              .then((_) {
            updateList();
          });
        },
        tooltip: 'Add Goal',
        backgroundColor: const Color(0xFF0A84FF),
        child: const Icon(Icons.add),
      ),
    );
  }

  void deleteItem(int index) async {
    try {
      setState(() {
        listGoal.removeAt(index);
      });
      await servicetoaddtext?.removeTodo(index);
    } catch (e) {
      debugPrint("Error deleting item: $e");
    }
  }
}

class GoalData {
  final Color color;
  final Icon icon;

  GoalData({required this.color, required this.icon});
}
