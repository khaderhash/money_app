import 'package:flutter/material.dart';
import 'package:myappmoney2/Screens/HomePage.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/sharedprefcharex.dart';

class Expencesmoney extends StatefulWidget {
  Expencesmoney({super.key});
  static String id = 'Expencesmoney';

  @override
  State<Expencesmoney> createState() => _ExpencesmoneyState();
}

class _ExpencesmoneyState extends State<Expencesmoney> {
  List<SalesData> expenseData = [];
  List<SalesData> incomeData = [];
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
    SharedPreferencesservicechar(sharedPreferences)
        .getNumbers()
        .then((numbers) {
      setState(() {
        if (numbers.isEmpty) {
          expenseData = [];
          incomeData = [];
          totalExpenses = 0;
          totalIncome = 0;
        } else {
          expenseData = [];
          incomeData = [];
          totalExpenses = 0;
          totalIncome = 0;

          for (var number in numbers) {
            if (number['type'] == 'expense') {
              expenseData.add(SalesData(
                  'Expense ${expenseData.length + 1}', number['value']));
              totalExpenses += number['value'];
            } else if (number['type'] == 'income') {
              incomeData.add(SalesData(
                  'Income ${incomeData.length + 1}', number['value']));
              totalIncome += number['value'];
            }
          }
        }
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Homepage.id);
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
                      title: ChartTitle(text: 'Financial Data (Bar Chart)'),
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
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: SfCircularChart(
                      title: ChartTitle(text: 'Income vs Expenses (Pie Chart)'),
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
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Difference: ${(totalIncome - totalExpenses).toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
    );
  }
}

class SalesData {
  final String month;
  final double sales;

  SalesData(this.month, this.sales);
}
