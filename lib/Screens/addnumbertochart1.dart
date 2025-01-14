import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/sharedprefcharex.dart';

class AddNumberToChart extends StatefulWidget {
  const AddNumberToChart({super.key});
  static String id = 'addnumbertochart';

  @override
  State<AddNumberToChart> createState() => _AddNumberToChartState();
}

class _AddNumberToChartState extends State<AddNumberToChart> {
  TextEditingController valueController = TextEditingController();
  String selectedType = 'expense'; // النوع الافتراضي

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Financial Data"),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // إدخال القيمة
            TextField(
              controller: valueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter Value",
                hintText: "Enter the amount",
                border: const OutlineInputBorder(),
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
            const SizedBox(height: 20),
            // اختيار النوع (مصاريف أو مداخيل)
            DropdownButtonFormField<String>(
              value: selectedType,
              onChanged: (value) {
                setState(() {
                  selectedType = value!;
                });
              },
              items: const [
                DropdownMenuItem(value: 'expense', child: Text('Expense')),
                DropdownMenuItem(value: 'income', child: Text('Income')),
              ],
              decoration: const InputDecoration(
                labelText: "Select Type",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // زر الحفظ
            ElevatedButton(
              onPressed: () async {
                final sharedPreferences = await SharedPreferences.getInstance();
                double? value = double.tryParse(valueController.text);

                if (value != null && value > 0) {
                  // إضافة البيانات حسب النوع
                  await SharedPreferencesservicechar(sharedPreferences)
                      .addNumber(value, selectedType);
                  Navigator.pop(context, true); // العودة بعد الإضافة
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Invalid Input"),
                      content: const Text("Please enter a positive number."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
