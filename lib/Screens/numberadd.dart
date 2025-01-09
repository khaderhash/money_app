import 'package:flutter/material.dart';
import 'package:moneyappp/services/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moneyappp/services/shared_preferences_number.dart';

class addnumber extends StatefulWidget {
  const addnumber({super.key, this.title, this.index});
  final String? title;
  final int? index;
  static String id = 'addnumber';

  @override
  State<addnumber> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<addnumber> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    controller = TextEditingController(text: widget.title);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: 'Enter a number',
                  fillColor: Colors.white70),
            ),
          ),
          Container(
            width: double.infinity,
            height: 50,
            margin: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  final sharedPreferences =
                      await SharedPreferences.getInstance();
                  final value = double.tryParse(controller.text) ?? 0.0;
                  if ((widget.title?.isEmpty ?? true)) {
                    SharedPreferencesservice(sharedPreferences)
                        .addNumber(value);
                  } else {
                    SharedPreferencesservice(sharedPreferences)
                        .updateNumber(widget.index ?? 0, value);
                  }
                  Navigator.pop(context);
                }
              },
              child: Text("Save"),
            ),
          ),
        ],
      ),
    );
  }
}
