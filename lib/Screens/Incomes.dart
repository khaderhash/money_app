import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myappmoney2/compo/contentIL.dart';
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
  List<Map<String, dynamic>> listIncomes = [];

  final Map<String, incomeData> incomeListDATA = {
    "Salaries and Wages": incomeData(
      color: Colors.grey,
      icon: Icon(Icons.monetization_on_outlined),
    ),
    "Business": incomeData(
      color: Colors.yellowAccent,
      icon: Icon(Icons.monetization_on_outlined),
    ),
    "Gifts and Bonuses": incomeData(
      color: Colors.greenAccent,
      icon: Icon(Icons.monetization_on_outlined),
    ),
    "Other": incomeData(
      color: Colors.yellow,
      icon: Icon(Icons.monetization_on_outlined),
    ),
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
                          final type = income["type"];
                          final incomeInfo = incomeListDATA[type];
                          return PieChartSectionData(
                            value: income["value"],
                            color: incomeInfo?.color ?? Colors.grey,
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
                final type = listIncomes[index]["type"];
                final value = listIncomes[index]["value"];
                final incomesInfo = incomeListDATA[type];
                return ContentLE(
                  iconcolor: incomesInfo?.color?.withOpacity(0.2) ??
                      Colors.grey.withOpacity(0.2),
                  iconprimary: incomesInfo?.icon ??
                      const Icon(Icons.error, color: Colors.grey),
                  nameofcategory: type,
                  onpres: () async {
                    await servicetoaddnumber?.removeIncome(index);
                    updateList();
                  },
                  colorofmoney: incomesInfo?.color ?? Colors.grey,
                  valueofmoney: "\$${value.toStringAsFixed(2)}",
                  icondelete: const Icon(Icons.delete, color: Colors.red),
                );
                //
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

class incomeData {
  final Color color;
  final Icon icon;

  incomeData({required this.color, required this.icon});
}
