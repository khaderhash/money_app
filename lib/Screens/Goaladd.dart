import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/Shared_preferences_goal.dart';

class GoalsaddEdit extends StatefulWidget {
  GoalsaddEdit({super.key, this.title, this.index});
  static String id = "GoalsaddEdit";
  final String? title;
  final int? index;

  @override
  State<GoalsaddEdit> createState() => _GoalsState();
}

class _GoalsState extends State<GoalsaddEdit> {
  TextEditingController controller = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController currentAmountController = TextEditingController();
  TextEditingController addAmountController = TextEditingController();
  TextEditingController dueDateController = TextEditingController(); // إضافة حقل التاريخ
  SharedPreferencesServicegoals? servicetoaddtext;
  String? goalType = "اختياري"; // إجباري أو اختياري
  double currentAmount = 0;

  @override
  void initState() {
    super.initState();
    if (widget.title != null && widget.index != null) {
      // إذا كان هناك عنوان وindex، نكون في وضع التعديل
      _loadGoalData();
    }
  }

  // تحميل البيانات للهدف إذا كان في وضع التعديل
  _loadGoalData() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final goalsList = SharedPreferencesServicegoals(sharedPreferences).getTodo();
    final goalData = (await goalsList)[widget.index!];

    controller.text = goalData['goal'] ?? '';
    amountController.text = goalData['amount'] ?? '';
    currentAmountController.text = goalData['current_amount'] ?? '';
    goalType = goalData['type'] ?? 'اختياري';
    dueDateController.text = goalData['due_date'] ?? ''; // تحديث تاريخ الاستحقاق
    currentAmount = double.tryParse(goalData['current_amount'] ?? '0') ?? 0;
  }

  initSharedPreferences() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    servicetoaddtext = SharedPreferencesServicegoals(sharedPreferences);
  }

  @override
  Widget build(BuildContext context) {
    final double goalAmount = double.tryParse(amountController.text) ?? 0;

    final double percentage = currentAmount > 0
        ? (currentAmount / goalAmount) * 100
        : (goalAmount > 0 ? (currentAmount / goalAmount) * 100 : 0);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title?.isEmpty ?? false ? "Add Goal" : "Update Goal"),
        backgroundColor: const Color(0xFF0A84FF),
      ),
      backgroundColor: const Color(0xFF1C1C1E),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[300]),
                  hintText: 'Goal Name',
                  fillColor: const Color(0xFF2C2C2E),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: amountController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[300]),
                  hintText: 'Target Amount',
                  fillColor: const Color(0xFF2C2C2E),
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: currentAmountController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[300]),
                  hintText: 'Current Saved Amount',
                  fillColor: const Color(0xFF2C2C2E),
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: dueDateController, // حقل التاريخ
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[300]),
                  hintText: 'Due Date (YYYY-MM-DD)',
                  fillColor: const Color(0xFF2C2C2E),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<String>(
                value: goalType,
                dropdownColor: const Color(0xFF2C2C2E),
                onChanged: (String? newValue) {
                  setState(() {
                    goalType = newValue!;
                  });
                },
                items: <String>['اختياري', 'إجباري']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF2C2C2E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                ),
              ),
            ),
            if (widget.index != null) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Percentage: ${percentage.toStringAsFixed(2)}%",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: addAmountController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey[300]),
                    hintText: 'Add New Amount',
                    fillColor: const Color(0xFF2C2C2E),
                  ),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () async {
                  final newSavedAmount = (double.tryParse(currentAmountController.text) ?? 0) +
                      (double.tryParse(addAmountController.text) ?? 0);

                  final sharedPreferences = await SharedPreferences.getInstance();
                  if (widget.index == null) {
                    // إضافة هدف جديد
                    SharedPreferencesServicegoals(sharedPreferences).addTodo({
                      'goal': controller.text,
                      'amount': amountController.text,
                      'current_amount': newSavedAmount.toString(),
                      'type': goalType ?? 'اختياري',
                      'due_date': dueDateController.text, // إضافة التاريخ
                    });
                  } else {
                    // تحديث هدف موجود
                    SharedPreferencesServicegoals(sharedPreferences).updateTodo(widget.index!, {
                      'goal': controller.text,
                      'amount': amountController.text,
                      'current_amount': newSavedAmount.toString(),
                      'type': goalType ?? 'اختياري',
                      'due_date': dueDateController.text, // إضافة التاريخ
                    });
                  }
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A84FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(widget.index == null ? 'Add Goal' : 'Update Goal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
