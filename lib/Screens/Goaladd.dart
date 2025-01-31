import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../compo/AppBarcom.dart';
import '../constants.dart';

class AddGoalScreen extends StatefulWidget {
  final Function onGoalAdded;
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
      "startDate": DateTime.now().toIso8601String(),
      "deadline": selectedDate?.toIso8601String(),
    };

    goals.add(newGoal);
    await prefs.setString("goals", json.encode(goals));

    widget.onGoalAdded();
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
      appBar: Appbarofpage(TextPage: "Goal Add"),
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
                    labelText: "Goal Name",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: hight(context) * .02),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: hight(context) * .007),
                child: TextField(
                  controller: totalAmountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Total Amount",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: hight(context) * .02),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: hight(context) * .007),
                child: TextField(
                  controller: savedAmountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Saved Amount",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: hight(context) * .02),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: hight(context) * .007),
                child: DropdownButtonFormField<String>(
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
              ),
              SizedBox(height: hight(context) * .006),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: hight(context) * .007),
                child: Row(
                  children: [
                    const Text("Select Target Date and Time:"),
                    TextButton(
                      onPressed: pickDateTime,
                      child: Text(
                        selectedDate == null
                            ? "Choose Date & Time"
                            : "${selectedDate!.toLocal()}".split('.')[0],
                        style: TextStyle(
                          color: const Color(0xFF482F37),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: hight(context) * .012),
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
                    onPressed: saveGoal,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                      backgroundColor: Color(
                          0xFF507da0), // اجعل الخلفية شفافة لتظهر التدرجات
                      // اجعل الخلفية شفافة لتظهر التدرجات
                      shadowColor: Colors.transparent, // إزالة الظل الافتراضي
                    ),
                    child: const Text(
                      "Save Goal",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors
                            .white, // اجعل النص أبيض ليظهر بوضوح على التدرج
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
