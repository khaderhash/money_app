import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:myappmoney2/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/Shared_preferences_goal.dart';
import '../services/shared_preferences_expences.dart';
import 'Goaladd.dart';
import 'package:intl/intl.dart'; // إضافة هذه الحزمة لتنسيق الأرقام

class Goals extends StatefulWidget {
  Goals({super.key});
  static String id = "Goals";

  @override
  State<Goals> createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  List<Map<String, String>> listData = [];
  var servicetoaddtext;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  initSharedPreferences() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    servicetoaddtext = SharedPreferencesServicegoals(sharedPreferences);
    listData = await servicetoaddtext?.getTodo() ?? [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(locale: 'en_US', symbol: '\$'); // تنسيق العملات
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E), // خلفية داكنة
      appBar: AppBar(
        backgroundColor: const Color(0xFF264653), // لون أزرق أساسي
        elevation: 0,
        title: const Text(
          'Goals',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: listData.isEmpty
          ? const Center(
              child: Text(
                'No goals added yet!',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: listData.length,
              itemBuilder: (context, index) {
                final goal = listData[index];
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
                      goal['goal'] ?? '',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            Colors.white, // النص باللون الأبيض لزيادة التباين
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // نوع الهدف
                        Text(
                          'Goal Type: ${goal['type']}',
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // المبلغ المطلوب جمعه
                        Text(
                          'Target Amount: ${currencyFormat.format(targetAmount)}',
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        // المبلغ الذي تم جمعه
                        const SizedBox(height: 5),
                        Text(
                          'Amount Saved: ${currencyFormat.format(currentAmount)}',
                          style: const TextStyle(
                            color: Colors.orangeAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // تاريخ الاستحقاق
                        Text(
                          'Due Date: ${goal['due_date']}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // شريط التقدم
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
                        initSharedPreferences();
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
            initSharedPreferences();
          });
        },
        tooltip: 'Add Goal',
        backgroundColor: const Color(0xFF0A84FF), // لون أزرق أساسي
        child: const Icon(Icons.add),
      ),
    );
  }

  void deleteItem(int index) async {
    setState(() {
      listData.removeAt(index);
    });
    await servicetoaddtext?.removeTodo(index);
  }
}
