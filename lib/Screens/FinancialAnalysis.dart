import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/Shared_preferences_incomes.dart';
import '../services/shared_preferences_expences.dart';

class Financialanalysis extends StatefulWidget {
  Financialanalysis({super.key});
  static String id = 'Expencesmoney';

  @override
  State<Financialanalysis> createState() => _FinancialanalysisState();
}

class _FinancialanalysisState extends State<Financialanalysis> {
  List<SalesData> expenseData = [];
  List<SalesData> incomeData = [];
  double totalExpenses = 0;
  double totalIncome = 0;
  bool isLoading = true;
  String selectedTimePeriod = 'Last Month'; // Default selection

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    // جلب بيانات المصاريف بناءً على الفترة الزمنية المختارة
    SharedPreferencesServiceexpenses(sharedPreferences)
        .getExpensesForTimePeriod(selectedTimePeriod)
        .then((expenses) {
      setState(() {
        expenseData = expenses;
        totalExpenses = expenses.fold(0, (sum, item) => sum + item.sales);
      });
    });

    // جلب بيانات المداخيل بناءً على الفترة الزمنية المختارة
    SharedPreferencesServiceIncomes(sharedPreferences)
        .getIncomesForTimePeriod(selectedTimePeriod)
        .then((incomes) {
      setState(() {
        incomeData = incomes;
        totalIncome = incomes.fold(0, (sum, item) => sum + item.sales);
        isLoading = false; // البيانات جاهزة الآن
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
        title: const Text("Financial Analysis Chart"),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // إضافة قائمة منسدلة لاختيار الفترة الزمنية
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: DropdownButton<String>(
                    value: selectedTimePeriod,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedTimePeriod = newValue!;
                        isLoading = true; // إعادة تحميل البيانات
                        loadData(); // تحميل البيانات بناءً على الفترة الزمنية الجديدة
                      });
                    },
                    items: <String>['Last Week', 'Last Month']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),

                // عرض المخطط فقط إذا كانت البيانات موجودة
                if (expenseData.isNotEmpty || incomeData.isNotEmpty)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        primaryYAxis: NumericAxis(
                            minimum: 0,
                            maximum: (totalIncome + totalExpenses) * 1.1,
                            interval: (totalIncome + totalExpenses) / 10),
                        title: ChartTitle(
                            text: 'Financial Data ($selectedTimePeriod)'),
                        legend: Legend(isVisible: true),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <CartesianSeries>[
                          ColumnSeries<SalesData, String>(
                            dataSource: expenseData,
                            xValueMapper: (SalesData sales, _) => sales.month,
                            yValueMapper: (SalesData sales, _) => sales.sales,
                            name: 'Expenses',
                            color: Colors.red,
                            dataLabelSettings:
                                const DataLabelSettings(isVisible: true),
                          ),
                          ColumnSeries<SalesData, String>(
                            dataSource: incomeData,
                            xValueMapper: (SalesData sales, _) => sales.month,
                            yValueMapper: (SalesData sales, _) => sales.sales,
                            name: 'Income',
                            color: Colors.green,
                            dataLabelSettings:
                                const DataLabelSettings(isVisible: true),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'No data available for this period. Please add some data first.',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ),

                // مخطط دائري للمقارنة بين المصاريف والمداخيل إذا كانت البيانات موجودة
                if (expenseData.isNotEmpty || incomeData.isNotEmpty)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: SfCircularChart(
                        title:
                            ChartTitle(text: 'Income vs Expenses (Pie Chart)'),
                        legend: Legend(
                          isVisible: true,
                          overflowMode: LegendItemOverflowMode.wrap,
                        ),
                        series: <CircularSeries>[
                          PieSeries<SalesData, String>(
                            dataSource: [
                              SalesData('Expenses', totalExpenses),
                              SalesData('Income', totalIncome),
                            ],
                            xValueMapper: (SalesData data, _) => data.month,
                            yValueMapper: (SalesData data, _) => data.sales,
                            dataLabelSettings:
                                const DataLabelSettings(isVisible: true),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'No data available for this period. Please add some data first.',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ),

                // عرض الفارق بين المصاريف والمداخيل إذا كانت البيانات موجودة
                if (expenseData.isNotEmpty || incomeData.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Difference: ${(totalIncome - totalExpenses).toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                // عرض إجمالي المصاريف والمداخيل إذا كانت البيانات موجودة
                if (expenseData.isNotEmpty || incomeData.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Total Expenses: ${totalExpenses.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                if (expenseData.isNotEmpty || incomeData.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Total Income: ${totalIncome.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
    );
  }
}

// البيانات للمصاريف والمداخيل
class SalesData {
  final String month;
  final double sales;

  SalesData(this.month, this.sales);
}
