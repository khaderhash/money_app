import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myappmoney2/services/shared_preferences_number.dart';
import '../services/Shared_preferences_incomes.dart';
import 'AddIncomes.dart';

class IncomesScreens extends StatefulWidget {
  const IncomesScreens({super.key});
  static String id = "IncomesScreen";

  @override
  State<IncomesScreens> createState() => _IncomesState();
}

class _IncomesState extends State<IncomesScreens> {
  SharedPreferencesServiceIncomes? servicetoaddnumber;
  List<Map<String, dynamic>> listIncomes =
      []; // تحتوي على المداخل المالية والأنواع

  final Map<String, Color> incomeColors = {
    "وظيفة": Colors.green,
    "استثمار": Colors.blue,
    "مبيعات": Colors.orange,
    "مكافآت": Colors.red,
  };

  @override
  void initState() {
    initSharedPreferences();
    super.initState();
  }

  initSharedPreferences() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    servicetoaddnumber = SharedPreferencesServiceIncomes(sharedPreferences);
    listIncomes = await servicetoaddnumber?.getIncomes() ?? [];
    setState(() {});
  }

  void updateList() async {
    listIncomes = await servicetoaddnumber?.getIncomes() ?? [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Incomes Chart"),
        backgroundColor: const Color(0xFF264653),
      ),
      body: Column(
        children: [
          // مخطط دائري للمداخل المالية
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: PieChart(
                PieChartData(
                  sections: listIncomes.isEmpty
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
                      : listIncomes.map((income) {
                          return PieChartSectionData(
                            value: income["value"],
                            color: incomeColors[income["type"]] ?? Colors.grey,
                            title: income["value"].toString(),
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
                  sectionsSpace:
                      4, // إضافة مسافة بين الأجزاء لزيادة وضوح المخطط
                ),
              ),
            ),
          ),

          // قائمة المداخل المالية
          Expanded(
            flex: 3,
            child: ListView.builder(
              itemCount: listIncomes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(
                    Icons.check_circle,
                    color:
                        incomeColors[listIncomes[index]["type"]] ?? Colors.grey,
                  ),
                  title: Text(
                    "${listIncomes[index]["type"]}: ${listIncomes[index]["value"]}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await servicetoaddnumber?.removeIncome(index);
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
            builder: (context) => AddIncomes(),
          ));
          updateList();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
