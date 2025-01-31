import 'package:flutter/material.dart';
import 'package:myappmoney2/compo/AppBarcom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
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
      appBar: Appbarofpage(TextPage: "Add Expences"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: hight(context) * .028),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: hight(context) * .02),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hight(context) * .007),
              child: TextField(
                controller: valueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter Expense Value",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: hight(context) * .03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hight(context) * .007),
              child: DropdownButtonFormField<String>(
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
            ),
            SizedBox(height: hight(context) * .03),
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
                  onPressed: () async {
                    if (valueController.text.isNotEmpty) {
                      final sharedPreferences =
                          await SharedPreferences.getInstance();
                      final value =
                          double.tryParse(valueController.text) ?? 0.0;
                      final expense = {
                        "value": value,
                        "type": selectedType,
                        "date":
                            DateTime.now().toString(), // إضافة التاريخ الحالي
                      };
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
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                    backgroundColor:
                        Color(0xFF507da0), // اجعل الخلفية شفافة لتظهر التدرجات
                    shadowColor: Colors.transparent, // إزالة الظل الافتراضي
                  ),
                  child: const Text(
                    "Add",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors
                            .white // اجعل النص أبيض ليظهر بوضوح على التدرج
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
