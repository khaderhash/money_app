import 'package:flutter/material.dart';
import 'package:myappmoney2/compo/AppBarcom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/shared_preferences_expences.dart';

class AddExpences extends StatefulWidget {
  const AddExpences({super.key});
  static String id = 'addnumber';

  @override
  State<AddExpences> createState() => _AddNumberState();
}

class _AddNumberState extends State<AddExpences> {
  TextEditingController valueController = TextEditingController();
  String selectedType = "Shopping";

  final List<String> expenseTypes = [
    "Food & Drinks",
    "Shopping",
    "Housing",
    "Transportation",
    "Vehicle",
    "Others"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarofpage(TextPage: "AddExpences"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: valueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter Expense Value",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedType,
              items: expenseTypes
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
              decoration: InputDecoration(
                labelText: "Select Expense Type",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (valueController.text.isNotEmpty) {
                    final sharedPreferences =
                        await SharedPreferences.getInstance();
                    final value = double.tryParse(valueController.text) ?? 0.0;
                    final expense = {"value": value, "type": selectedType};
                    final service =
                        SharedPreferencesServiceexpenses(sharedPreferences);

                    // تحديث القائمة بحيث يضاف المصروف في البداية
                    List<Map<String, dynamic>> currentExpenses =
                        await service.getExpenses() ?? [];
                    currentExpenses.insert(
                        0, expense); // الإدراج في بداية القائمة

                    await service
                        .saveExpenses(currentExpenses); // حفظ القائمة الجديدة
                    Navigator.pop(context);
                  }
                },
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
