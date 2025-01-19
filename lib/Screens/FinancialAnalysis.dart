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
  List<Map<String, dynamic>> expenses = [];
  List<Map<String, dynamic>> incomes = [];
  double totalExpenses = 0;
  double totalIncome = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    // جلب بيانات المصاريف باستخدام getExpenses
    SharedPreferencesServiceexpenses(sharedPreferences)
        .getExpenses()
        .then((expenseData) {
      setState(() {
        expenses = expenseData;
        totalExpenses = expenses.fold(0, (sum, item) => sum + item['value']);
      });
    });

    // جلب بيانات المداخيل باستخدام getIncomes
    SharedPreferencesServiceIncomes(sharedPreferences)
        .getIncomes()
        .then((incomeData) {
      setState(() {
        incomes = incomeData;
        totalIncome = incomes.fold(0, (sum, item) => sum + item['value']);
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
        backgroundColor: Colors.teal[700],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              // جعل الصفحة قابلة للتمرير
              child: Column(
                children: [
                  // عرض الفرق المالي في بداية الصفحة
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Financial Difference: ${(totalIncome - totalExpenses).toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: totalIncome >= totalExpenses
                              ? Colors.green
                              : Colors.red),
                    ),
                  ),

                  // عرض المخطط البياني (Bar Chart) مع الألوان المحترفة
                  if (totalExpenses > 0 || totalIncome > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        primaryYAxis: NumericAxis(
                          minimum: 0,
                          maximum: (totalIncome + totalExpenses) * 1.1,
                          interval: (totalIncome + totalExpenses) / 10,
                        ),
                        title: ChartTitle(
                            text: 'Financial Data (Total Income vs Expenses)',
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal[700],
                            )),
                        legend: Legend(
                            isVisible: true,
                            position: LegendPosition.bottom,
                            backgroundColor: Colors.transparent),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <CartesianSeries>[
                          ColumnSeries<SalesData, String>(
                            dataSource: [
                              SalesData('Expenses', totalExpenses),
                              SalesData('Income', totalIncome),
                            ],
                            xValueMapper: (SalesData sales, _) => sales.month,
                            yValueMapper: (SalesData sales, _) => sales.sales,
                            name: 'Financial Data',
                            color: Colors.red.withOpacity(0.7),
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true),
                          ),
                        ],
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'No data available. Please add some data first.',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),

                  // عرض المخطط الدائري (Pie Chart)
                  if (totalExpenses > 0 || totalIncome > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      child: SfCircularChart(
                        title: ChartTitle(
                          text: 'Income vs Expenses',
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal[700],
                          ),
                        ),
                        legend: Legend(
                          isVisible: true,
                          overflowMode: LegendItemOverflowMode.wrap,
                          position: LegendPosition.bottom,
                          backgroundColor: Colors.transparent,
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
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'No data available. Please add some data first.',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Expenses and Incomes',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        // عرض المصاريف
                        if (expenses.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: expenses.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Icon(
                                  Icons.arrow_downward,
                                  color: Colors.red,
                                ),
                                title: Text(
                                  '${expenses[index]["type"]}: ${expenses[index]["value"]}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                subtitle: Text(
                                  'Date: ${expenses[index]["date"]}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              );
                            },
                          ),
                        const SizedBox(height: 10),
                        // عرض المداخيل
                        if (incomes.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: incomes.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Icon(
                                  Icons.arrow_upward,
                                  color: Colors.green,
                                ),
                                title: Text(
                                  '${incomes[index]["type"]}: ${incomes[index]["value"]}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                subtitle: Text(
                                  'Date: ${incomes[index]["date"]}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class SalesData {
  final String month;
  final double sales;

  SalesData(this.month, this.sales);
}
