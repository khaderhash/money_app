import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../compo/AppBarcom.dart';
import '../constants.dart';
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

  get saveGoal => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarofpage(TextPage: "Add Incomes"),
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
                  labelText: "Enter Income Value",
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
                      final income = {"value": value, "type": selectedType};

                      // استخدام الخدمة لإضافة الدخل
                      SharedPreferencesServiceIncomes(sharedPreferences)
                          .addIncome(income);

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
