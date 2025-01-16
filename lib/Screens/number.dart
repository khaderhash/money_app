import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myappmoney2/services/shared_preferences_number.dart';

import '../services/shared_preferences.dart';
import 'numberadd.dart';

class NumberScreen extends StatefulWidget {
  const NumberScreen({super.key});
  static String id = "NumberScreen";

  @override
  State<NumberScreen> createState() => _ExpensesState();
}

class _ExpensesState extends State<NumberScreen> {
  SharedPreferencesServiceexpenses? servicetoaddnumber;
  List<Map<String, dynamic>> listExpenses = []; // تحتوي على الأرقام والأنواع

  final Map<String, Color> expenseColors = {
    "طعام": Colors.green,
    "سكن": Colors.blue,
    "بنزين": Colors.orange,
    "مصاريف اعتيادية": Colors.red,
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
          // مخطط دائري
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
                          return PieChartSectionData(
                            value: expense["value"],
                            color:
                                expenseColors[expense["type"]] ?? Colors.grey,
                            title: expense["value"].toString(),
                            radius: 50,
                            titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          );
                        }).toList(),
                  centerSpaceRadius: 40,
                  borderData: FlBorderData(show: false),
                  sectionsSpace:
                      4, // إضافة مسافة بين الأجزاء لزيادة وضوح المخطط
                ),
              ),
            ),
          ),

          // قائمة المصاريف
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: listExpenses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(
                    Icons.check_circle,
                    color: expenseColors[listExpenses[index]["type"]] ??
                        Colors.grey,
                  ),
                  title: Text(
                    "${listExpenses[index]["type"]}: ${listExpenses[index]["value"]}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await servicetoaddnumber?.removeExpense(index);
                      updateList();
                    },
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
            builder: (context) => addnumber(),
          ));
          updateList();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
