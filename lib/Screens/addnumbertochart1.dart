import 'package:flutter/material.dart';
import 'package:myappmoney2/services/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myappmoney2/services/shared_preferences_number.dart';

class addnumbertochart extends StatefulWidget {
  const addnumbertochart({super.key});
  static String id = 'addnumbertochart';

  @override
  State<addnumbertochart> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<addnumbertochart> {
  TextEditingController controller = TextEditingController();

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
                  fillColor: Colors.black),
            ),
          ),
          Container(
            width: double.infinity,
            height: 50,
            margin: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  final sharedPreferences = await SharedPreferences.getInstance();
                  final value = double.tryParse(controller.text) ?? 0.0;
                  SharedPreferencesservice(sharedPreferences).addNumber(value);
                  Navigator.pop(context, true); // إرجاع true لتحديث البيانات
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
