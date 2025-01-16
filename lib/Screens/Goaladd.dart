import 'package:flutter/material.dart';
import 'package:myappmoney2/Screens/Goals.dart';
import 'package:myappmoney2/constants.dart';
import 'package:myappmoney2/services/shared_preferences_expences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/Shared_preferences_goal.dart';

class Goalsadd extends StatefulWidget {
  Goalsadd({super.key, this.title, this.index});
  static String id = "Goalsadd";
  final String? title;
  final int? index;

  @override
  State<Goalsadd> createState() => _GoalsState();
}

class _GoalsState extends State<Goalsadd> {
  TextEditingController controller = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController currentAmountController = TextEditingController();
  SharedPreferencesServicegoals? servicetoaddtext;
  String? goalType = "اختياري"; // إجباري أو اختياري

  @override
  void initState() {
    controller = TextEditingController(text: widget.title);
    super.initState();
  }

  initSharedPreferences() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    servicetoaddtext = SharedPreferencesServicegoals(sharedPreferences);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey[800]),
                hintText: 'Create a goal',
                fillColor: Colors.white70,
              ),
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
                hintStyle: TextStyle(color: Colors.grey[800]),
                hintText: 'Enter the target amount',
                fillColor: Colors.white70,
              ),
              keyboardType: TextInputType.number,
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
                hintStyle: TextStyle(color: Colors.grey[800]),
                hintText: 'Amount already saved',
                fillColor: Colors.white70,
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: goalType,
              onChanged: (String? newValue) {
                setState(() {
                  goalType = newValue!;
                });
              },
              items: <String>['اختياري', 'إجباري']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Container(
            width: width(context),
            height: 50,
            margin: EdgeInsets.only(left: 16, right: 16),
            child: ElevatedButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  final sharedPreferences =
                      await SharedPreferences.getInstance();
                  if (widget.title?.isEmpty ?? true) {
                    SharedPreferencesServicegoals(sharedPreferences)
                        .addTodo({
                      'goal': controller.text,
                      'amount': amountController.text,
                      'current_amount': currentAmountController.text,
                    });
                  } else {
                    setState(() {
                      SharedPreferencesServicegoals(sharedPreferences)
                          .updateTodo(widget.index ?? 0, {
                        'goal': controller.text,
                        'amount': amountController.text,
                        'current_amount': currentAmountController.text,
                      });
                    });
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(widget.title?.isEmpty ?? false ? "Add" : "Update"),
            ),
          )
        ],
      ),
    );
  }
}
