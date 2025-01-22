import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddGoalScreen extends StatefulWidget {
  final Function onGoalAdded; // إضافة المعامل هنا
  static String id = "AddGoalScreen";

  const AddGoalScreen({Key? key, required this.onGoalAdded}) : super(key: key);

  @override
  _AddGoalScreenState createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController savedAmountController = TextEditingController();
  String selectedType = "Default Type";
  DateTime? selectedDate;

  final List<String> goalTypes = [
    "Default Type",
    "Education",
    "Travel",
    "Savings",
    "Others"
  ];

  Future<void> saveGoal() async {
    if (nameController.text.isEmpty || totalAmountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString("goals");
    final List goals = data != null ? json.decode(data) : [];

    final Map<String, dynamic> newGoal = {
      "name": nameController.text,
      "totalAmount": double.tryParse(totalAmountController.text) ?? 0.0,
      "savedAmount": double.tryParse(savedAmountController.text) ?? 0.0,
      "type": selectedType,
      "date":
          selectedDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };

    goals.add(newGoal);
    await prefs.setString("goals", json.encode(goals));

    widget.onGoalAdded(); // استدعاء الدالة الممررة لتحديث الأهداف
    Navigator.pop(context);
  }

  Future<void> pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Goal"),
        backgroundColor: const Color(0xFF264653),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Goal Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: totalAmountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Total Amount",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: savedAmountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Saved Amount",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedType,
                items: goalTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedType = value ?? "Default Type";
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Goal Type",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text("Select Target Date and Time:"),
                  TextButton(
                    onPressed: pickDateTime,
                    child: Text(
                      selectedDate == null
                          ? "Choose Date & Time"
                          : "${selectedDate!.toLocal()}".split('.')[0],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveGoal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A84FF),
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
                  "Save Goal",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
