import 'package:flutter/material.dart';
import 'package:moneyappp/Screens/Expenses.dart';
import 'package:moneyappp/constants.dart';
import 'package:moneyappp/services/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key, this.title, this.index});
  static String id = "addtodo";
  final String? title;
  final int? index;

  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    controller = TextEditingController(text: widget.title);

    super.initState();
  }

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
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey[800]),
                  hintText: 'creating a record',
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
                  final sharedPrefernces =
                      await SharedPreferences.getInstance();
                  if (widget.title?.isEmpty ?? false) {
                    SharedPreferencesService(sharedPrefernces)
                        .addTodo(controller.text);
                  } else {
                    SharedPreferencesService(sharedPrefernces)
                        .updateTodo(widget.index ?? 0, controller.text);
                  }
                  SharedPreferencesService(sharedPrefernces)
                      .addTodo(controller.text);
                  Navigator.pop(context);
                }
              },
              child: Text("text"),
            ),
          )
        ],
      ),
    );
  }
}
