import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myappmoney2/compo/AppBarcom.dart';
import 'package:myappmoney2/constants.dart';
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
  String getDisplayText() {
    if (selectedDate != null && selectedTime != null) {
      return "Time:  ${DateFormat('d/M/yyyy HH:mm').format(
        DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
          selectedTime!.hour,
          selectedTime!.minute,
        ),
      )}";
    }
    return "Select Due Date and Time:";
  }

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
      appBar: Appbarofpage(TextPage: "Add Reminder"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: hight(context) * .028),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: hight(context) * .02),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: hight(context) * .007),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Reminder Name",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: hight(context) * .03),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: hight(context) * .007),
                child: TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Amount",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: hight(context) * .006),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: hight(context) * .007),
                child: Row(
                  children: [
                    // const Text("Select Due Date and Time:"),
                    TextButton(
                      onPressed: pickDateTime,
                      child: Row(
                        children: [
                          Text(
                            selectedDate == null || selectedTime == null
                                ? "Choose Date and Time"
                                : "Time : ",
                            style: TextStyle(
                              fontSize: 18,
                              color: const Color(0xFF482F37),
                            ),
                          ),
                          Text(
                            selectedDate == null || selectedTime == null
                                ? ""
                                : "${DateFormat('d/M/yyyy HH:mm').format(
                                    DateTime(
                                      selectedDate!.year,
                                      selectedDate!.month,
                                      selectedDate!.day,
                                      selectedTime!.hour,
                                      selectedTime!.minute,
                                    ),
                                  )}",
                            style: TextStyle(
                              fontSize: 18,
                              color: const Color(0xFF482F37),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: hight(context) * .006),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hight(context) * .1),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF507da0), Color(0xFF507da0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8), // تعديل شكل الزر
                  ),
                  child: ElevatedButton(
                    onPressed: saveReminder,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                      backgroundColor: Color(
                          0xFF507da0), // اجعل الخلفية شفافة لتظهر التدرجات
                      // اجعل الخلفية شفافة لتظهر التدرجات
                      shadowColor: Colors.transparent, // إزالة الظل الافتراضي
                    ),
                    child: const Text(
                      "Save Reminder",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
