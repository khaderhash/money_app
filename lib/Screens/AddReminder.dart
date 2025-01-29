import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddReminderScreen extends StatefulWidget {
  final Function onReminderAdded;
  static String id = "AddReminderScreen";

  const AddReminderScreen({Key? key, required this.onReminderAdded})
      : super(key: key);

  @override
  _AddReminderScreenState createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> saveReminder() async {
    if (nameController.text.isEmpty ||
        amountController.text.isEmpty ||
        selectedDate == null ||
        selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    final DateTime finalDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString("reminders");
    final List reminders = data != null ? json.decode(data) : [];

    final Map<String, dynamic> newReminder = {
      "name": nameController.text,
      "amount": double.tryParse(amountController.text) ?? 0.0,
      "reminderDate": finalDateTime.toIso8601String(),
    };

    reminders.add(newReminder);
    await prefs.setString("reminders", json.encode(reminders));

    widget.onReminderAdded();
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
      setState(() {
        selectedDate = pickedDate;
      });
    }

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Reminder"),
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
                  labelText: "Reminder Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text("Select Due Date and Time:"),
                  TextButton(
                    onPressed: pickDateTime,
                    child: Text(
                      selectedDate == null
                          ? "Choose Date and Time"
                          : "${selectedDate!.toLocal()} ${selectedTime?.format(context) ?? ''}",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveReminder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A84FF),
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
                  "Save Reminder",
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
