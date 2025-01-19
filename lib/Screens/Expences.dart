import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/shared_preferences_expences.dart';
import 'AddExpences.dart';

class ExpencesScreens extends StatefulWidget {
  const ExpencesScreens({super.key});
  static String id = "NumberScreen";

  @override
  State<ExpencesScreens> createState() => _ExpensesState();
}

class _ExpensesState extends State<ExpencesScreens> {
  SharedPreferencesServiceexpenses? servicetoaddnumber;
  List<Map<String, dynamic>> listExpenses = []; // تحتوي على الأرقام والأنواع

  final Map<String, ExpenseData> expenseData = {
    "Food & Drinks":
        ExpenseData(color: Colors.green, icon: Icon(Icons.fastfood)),
    "Shopping":
        ExpenseData(color: Colors.blue, icon: Icon(Icons.shopping_cart)),
    "Housing": ExpenseData(color: Colors.orange, icon: Icon(Icons.home)),
    "Transportation":
        ExpenseData(color: Colors.red, icon: Icon(Icons.directions_bus)),
    "Vehicle": ExpenseData(
        color: Colors.deepPurpleAccent, icon: Icon(Icons.directions_car)),
    "Others": ExpenseData(color: Colors.grey, icon: Icon(Icons.more_horiz)),
  };

  @override
  void initState() {
    initSharedPreferences();
    super.initState();
  }

  initSharedPreferences() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    servicetoaddnumber = SharedPreferencesServiceexpenses(sharedPreferences);
    listExpenses = await servicetoaddnumber?.getExpenses() ?? [];
    setState(() {});
  }

  void updateList() async {
    listExpenses = await servicetoaddnumber?.getExpenses() ?? [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expenses Chart"),
        backgroundColor: const Color(0xFF264653),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: PieChart(
                PieChartData(
                  sections: listExpenses.isEmpty
                      ? [
                          PieChartSectionData(
                            value: 100,
                            color: Colors.grey,
                            title: "No Data",
                            radius: 50,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        ]
                      : listExpenses.map((expense) {
                          final type = expense["type"];
                          final expenseInfo = expenseData[type];
                          return PieChartSectionData(
                            value: expense["value"],
                            color: expenseInfo?.color ?? Colors.grey,
                            title: expense["value"].toString(),
                            radius: 50,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }).toList(),
                  centerSpaceRadius: 40,
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 4,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: listExpenses.length,
              itemBuilder: (context, index) {
                final type = listExpenses[index]["type"];
                final value = listExpenses[index]["value"];
                final expenseInfo = expenseData[type];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    height: 100, // زيادة ارتفاع الكونتينر
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // الأيقونة والنصوص
                        Row(
                          children: [
                            // أيقونة الفئة
                            Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: expenseInfo?.color?.withOpacity(0.2) ??
                                    Colors.grey.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: expenseInfo?.icon ??
                                  const Icon(Icons.error, color: Colors.grey),
                            ),
                            const SizedBox(width: 16),
                            // النصوص (اسم الفئة والقيمة)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // اسم الفئة
                                Text(
                                  type,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF264653),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // القيمة
                                Text(
                                  "\$${value.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: expenseInfo?.color ?? Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        // زر الحذف
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await servicetoaddnumber?.removeExpense(index);
                              updateList();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE78B00),
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddExpences(),
          ));
          updateList();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ExpenseData {
  final Color color;
  final Icon icon;

  ExpenseData({required this.color, required this.icon});
}
