import 'package:flutter/material.dart';
import 'package:myappmoney2/Screens/Goals.dart';
import 'package:myappmoney2/constants.dart';
import 'package:myappmoney2/services/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  SharedPreferencesService? servicetoaddtext;

  @override
  void initState() {
    controller = TextEditingController(text: widget.title);
    super.initState();
  }

  initSharedPreferences() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    servicetoaddtext = SharedPreferencesService(sharedPreferences);
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
                  fillColor: Colors.white70),
            ),
          ),
          Container(
            width: width(context),
            height: 50,
            margin: EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: ElevatedButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  final sharedPreferences =
                      await SharedPreferences.getInstance();
                  if (widget.title?.isEmpty ?? true) {
                    SharedPreferencesService(sharedPreferences)
                        .addTodo(controller.text);
                  } else {
                    setState(() {
                      SharedPreferencesService(sharedPreferences)
                          .updateTodo(widget.index ?? 0, controller.text);
                    });
                  }
                  // تأكد من التحديث بعد إضافة هدف جديد
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
