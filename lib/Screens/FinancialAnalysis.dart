import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../compo/AppBarcom.dart';
import '../services/Shared_preferences_incomes.dart';
import '../services/shared_preferences_expences.dart';

class Financialanalysis extends StatefulWidget {
  Financialanalysis({super.key});
  static String id = 'Expencesmoney';

  @override
  State<Financialanalysis> createState() => _FinancialanalysisState();
}

class _FinancialanalysisState extends State<Financialanalysis> {
  List<SalesData> expenses = []; // تغيير نوع المتغير إلى SalesData
  List<SalesData> incomes = []; //
  double totalExpenses = 0;
  double totalIncome = 0;
  bool isLoading = true;
  String selectedTimePeriod = 'Last Month'; // الفترة الافتراضية

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    // جلب بيانات المصاريف باستخدام getExpensesForTimePeriod
    SharedPreferencesServiceexpenses(sharedPreferences)
        .getExpensesForTimePeriod(selectedTimePeriod)
        .then((expenseData) {
      setState(() {
        expenses = expenseData;
        totalExpenses = expenses.fold(0, (sum, item) => sum + item.sales);
      });
    });

    // جلب بيانات المداخيل باستخدام getIncomes
    // جلب بيانات المداخيل باستخدام getIncomesForTimePeriod
    SharedPreferencesServiceIncomes(sharedPreferences)
        .getIncomesForTimePeriod(selectedTimePeriod)
        .then((incomeData) {
      setState(() {
        incomes = incomeData;
        totalIncome = incomes.fold(0, (sum, item) => sum + item.sales);
        isLoading = false; // البيانات جاهزة الآن
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarofpage(TextPage: "Financial analysis"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButton<String>(
                      value: selectedTimePeriod,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedTimePeriod = newValue!;
                          isLoading =
                              true; // إعادة تحميل البيانات عند تغيير الفترة الزمنية
                        });
                        loadData(); // إعادة تحميل البيانات بناءً على الفترة الزمنية المحددة
                      },
                      items: <String>[
                        'Last Week',
                        'Last Month',
                        'Last Year',
                        'Last 30 Days'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
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
                          text: 'Income vs Expenses',
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal[700],
                          ),
                        ),
                        legend: Legend(
                          isVisible: true,
                          position: LegendPosition.bottom,
                          backgroundColor: Colors.transparent,
                        ),
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <CartesianSeries>[
                          // عمود للمصاريف
                          ColumnSeries<SalesData, String>(
                            dataSource: [
                              SalesData('Expenses', totalExpenses),
                            ],
                            xValueMapper: (SalesData data, _) => data.month,
                            yValueMapper: (SalesData data, _) => data.sales,
                            name: 'Expenses',
                            color: Colors.red, // تخصيص لون المصاريف
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true),
                          ),
                          // عمود للمداخيل
                          ColumnSeries<SalesData, String>(
                            dataSource: [
                              SalesData('Income', totalIncome),
                            ],
                            xValueMapper: (SalesData data, _) => data.month,
                            yValueMapper: (SalesData data, _) => data.sales,
                            name: 'Income',
                            color: Colors.green, // تخصيص لون المداخيل
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true),
                          ),
                        ],
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
                        if (expenses.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: expenses.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Container(
                                  height: 100,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                expenses[index]
                                                    .month, // استخدام month بدلاً من ["type"]
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF264653),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                expenses[index]
                                                    .month, // استخدام month بدلاً من ["type"]
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.arrow_downward_rounded,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        if (incomes.isNotEmpty)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: incomes.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Container(
                                  height: 100,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                incomes[index].month,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF264653),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                incomes[index].month,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.arrow_upward_rounded,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
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
