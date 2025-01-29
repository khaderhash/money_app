import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../compo/AppBarcom.dart';
import '../services/Shared_preferences_incomes.dart';

class AddIncomes extends StatefulWidget {
  const AddIncomes({super.key});
  static String id = 'addIncomes';

  @override
  State<AddIncomes> createState() => _AddIncomesState();
}

class _AddIncomesState extends State<AddIncomes> {
  TextEditingController valueController = TextEditingController();
  String selectedType = "Salaries and Wages";

  final List<String> incomeTypes = [
    "Salaries and Wages",
    "Business",
    "Gifts and Bonuses",
    "Other"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarofpage(TextPage: "AddIncomes"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: valueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter Income Value",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedType,
              items: incomeTypes
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
                labelText: "Select Income Type",
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
                    final income = {"value": value, "type": selectedType};
                    SharedPreferencesServiceIncomes(sharedPreferences)
                        .addIncome(income);
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
