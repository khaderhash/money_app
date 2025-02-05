import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myappmoney2/compo/clickHomepage.dart';
import 'package:myappmoney2/compo/drawer.dart';
import 'package:myappmoney2/compo/outsidecs.dart';
import 'package:myappmoney2/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../services/Shared_preferences_incomes.dart';
import '../services/shared_preferences_expences.dart';
import 'login.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  static String id = "homepage";

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late SharedPreferencesServiceexpenses _expenseService;
  late SharedPreferencesServiceIncomes _incomeService;
  List<Map<String, dynamic>> _transactions = [];
  double totalExpenses = 0;
  double totalIncome = 0;
  bool isLoading = true;
  String selectedTimePeriod = 'Last Month';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeServices();
      checkLoginStatus();
      await loadData();
    });
  }

  Future<List<Map<String, dynamic>>> _getAllTransactions() async {
    if (_expenseService == null || _incomeService == null) return [];

    final expenses = await _expenseService.getExpenses();
    final incomes = await _incomeService.getIncomes();

    final allTransactions = [...expenses, ...incomes]
      ..removeWhere((t) => t['date'] == null)
      ..sort((a, b) {
        final dateA = DateTime.parse(a['date']);
        final dateB = DateTime.parse(b['date']);
        return dateB.compareTo(dateA);
      });

    return allTransactions;
  }

  Future<void> _initializeServices() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _expenseService = SharedPreferencesServiceexpenses(prefs);
      _incomeService = SharedPreferencesServiceIncomes(prefs);
    });
  }

  void checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLoggedIn') != true) {
      Navigator.pushReplacementNamed(context, loginpage.id);
    }
  }

  Future<void> loadData() async {
    if (_expenseService == null || _incomeService == null) return;

    setState(() => isLoading = true);

    final expenses =
        await _expenseService.getExpensesForTimePeriod(selectedTimePeriod);
    final incomes =
        await _incomeService.getIncomesForTimePeriod(selectedTimePeriod);
    final allTransactions = await _getAllTransactions();

    setState(() {
      totalExpenses = expenses.fold(0, (sum, item) => sum + item.sales);
      totalIncome = incomes.fold(0, (sum, item) => sum + item.sales);
      _transactions = allTransactions;
      isLoading = false;
    });
  }

  bool _isExpense(Map<String, dynamic> transaction) {
    return transaction.containsKey('value') ||
        (transaction.containsKey('type') && transaction['type'] == 'Expense');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerClass(
        accountName: 'khader',
        accountEmail: 'khader@gmail',
        accountInitial: 'K',
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight;
          final screenWidth = constraints.maxWidth;

          return isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: loadData,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      _buildHeaderSection(screenHeight, screenWidth),
                      _buildFinancialAnalysis(),
                      _buildTransactionList(),
                    ],
                  ),
                );
        },
      ),
    );
  }

  Widget _buildHeaderSection(double height, double width) {
    return SizedBox(
      height: height * 0.4,
      child: Stack(
        children: [
          ClipPath(
            clipper: OutSideCustomShape(),
            child: Container(
              width: width * 1,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2e495e), Color(0xFF507da0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: const Color(0xFF482F37), width: 2),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF482F37),
                    blurRadius: 3,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: width * 1,
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
            child: Column(
              children: [
                Text(
                  'Financial Difference: ${(totalIncome - totalExpenses).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: totalIncome >= totalExpenses
                        ? Colors.green
                        : Color(0xfff9f9f9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialAnalysis() {
    return Column(
      children: [
        DropdownButton<String>(
          value: selectedTimePeriod,
          items: ['Last Week', 'Last Month', 'Last 2 Months']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (value) => setState(() {
            selectedTimePeriod = value!;
            loadData();
          }),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        if (totalExpenses > 0 || totalIncome > 0) ...[
          _buildPieChart(),
          _buildFinancialChart(),
        ],
      ],
    );
  }

  Widget _buildPieChart() {
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
      height: MediaQuery.of(context).size.height * 0.44,
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
      decoration: BoxDecoration(
        color: Color(0xfff9f9f9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SfCircularChart(
        title: ChartTitle(text: 'Income vs Expenses'),
        legend: const Legend(isVisible: true, position: LegendPosition.bottom),
        series: <CircularSeries>[
          PieSeries<SalesData, String>(
            dataSource: [
              SalesData('Expenses', totalExpenses),
              SalesData('Income', totalIncome),
            ],
            xValueMapper: (data, _) => data.month,
            yValueMapper: (data, _) => data.sales,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialChart() {
    final double percentage = (totalExpenses / totalIncome * 100).clamp(0, 100);

    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
      height: MediaQuery.of(context).size.height * 0.5,
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xfffdfbfb), Color(0xffebedee)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.width * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Financial Overview',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.03,
                    vertical: MediaQuery.of(context).size.width * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: percentage > 75
                        ? Colors.red.shade100
                        : percentage > 50
                            ? Colors.orange.shade100
                            : Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${percentage.toStringAsFixed(1)}% Ratio',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      color: percentage > 75
                          ? Colors.red
                          : percentage > 50
                              ? Colors.orange
                              : Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SfCartesianChart(
              margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                labelRotation: -20,
                labelStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03),
                majorGridLines: const MajorGridLines(width: 0),
              ),
              primaryYAxis: NumericAxis(
                numberFormat: NumberFormat.compactCurrency(symbol: '\$'),
                axisLine: const AxisLine(width: 0),
                labelStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03),
                majorTickLines: const MajorTickLines(size: 0),
              ),
              legend: Legend(
                isVisible: true,
                position: LegendPosition.top,
                textStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.035),
              ),
              tooltipBehavior: TooltipBehavior(
                enable: true,
                header: '',
                format: '{point.x}: \$ {point.y}',
                canShowMarker: true,
                textStyle: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03),
              ),
              series: <CartesianSeries>[
                AreaSeries<SalesData, String>(
                  dataSource: [
                    SalesData('Income', totalIncome),
                    SalesData('Expenses', totalExpenses),
                    SalesData('Savings', totalIncome - totalExpenses),
                  ],
                  xValueMapper: (data, _) => data.month,
                  yValueMapper: (data, _) => data.sales,
                  name: 'Financial Trend',
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0.5),
                      Colors.blue.withOpacity(0.1)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderWidth: 3,
                  borderColor: Colors.blue,
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    shape: DataMarkerType.circle,
                    color: Colors.blue,
                    borderWidth: 2,
                    borderColor: Colors.white,
                  ),
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    textStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem(
                  color: Colors.greenAccent,
                  title: 'Total Income',
                  value: totalIncome,
                ),
                _buildLegendItem(
                  color: Colors.redAccent,
                  title: 'Total Expenses',
                  value: totalExpenses,
                ),
                _buildLegendItem(
                  color: Colors.blueAccent,
                  title: 'Net Savings',
                  value: totalIncome - totalExpenses,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildBarChart() {
  //   final double percentage = (totalExpenses / totalIncome * 100).clamp(0, 100);
  //
  //   return Container(
  //     margin: EdgeInsets.symmetric(
  //         horizontal: MediaQuery.of(context).size.width * 0.09),
  //     height: MediaQuery.of(context).size.height * 0.5,
  //     padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
  //     decoration: BoxDecoration(
  //       color: Color(0xfff9f9f9),
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.1),
  //           spreadRadius: 3,
  //           blurRadius: 7,
  //           offset: Offset(0, 3),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       children: [
  //         Padding(
  //           padding: EdgeInsets.only(
  //               bottom: MediaQuery.of(context).size.width * 0.03),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 'Financial Overview',
  //                 style: TextStyle(
  //                   fontSize: MediaQuery.of(context).size.width * 0.045,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.deepPurple,
  //                 ),
  //               ),
  //               Container(
  //                 padding: EdgeInsets.symmetric(
  //                   horizontal: MediaQuery.of(context).size.width * 0.03,
  //                   vertical: MediaQuery.of(context).size.width * 0.01,
  //                 ),
  //                 decoration: BoxDecoration(
  //                   color: percentage > 75
  //                       ? Colors.red.shade100
  //                       : percentage > 50
  //                       ? Colors.orange.shade100
  //                       : Colors.green.shade100,
  //                   borderRadius: BorderRadius.circular(8),
  //                 ),
  //                 child: Text(
  //                   '${percentage.toStringAsFixed(1)}% Expense Ratio',
  //                   style: TextStyle(
  //                     fontSize: MediaQuery.of(context).size.width * 0.035,
  //                     color: percentage > 75
  //                         ? Colors.red
  //                         : percentage > 50
  //                         ? Colors.orange
  //                         : Colors.green,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Expanded(
  //           child: SfCartesianChart(
  //             margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
  //             plotAreaBorderWidth: 0,
  //             primaryXAxis: CategoryAxis(
  //               labelRotation: -30,
  //               labelStyle: TextStyle(
  //                   fontSize: MediaQuery.of(context).size.width * 0.03),
  //               majorGridLines: const MajorGridLines(width: 0),
  //             ),
  //             primaryYAxis: NumericAxis(
  //               numberFormat: NumberFormat.compactCurrency(symbol: '\$'),
  //               axisLine: const AxisLine(width: 0),
  //               labelStyle: TextStyle(
  //                   fontSize: MediaQuery.of(context).size.width * 0.03),
  //               majorTickLines: const MajorTickLines(size: 0),
  //             ),
  //             legend: Legend(
  //               isVisible: true,
  //               position: LegendPosition.top,
  //               textStyle: TextStyle(
  //                   fontSize: MediaQuery.of(context).size.width * 0.035),
  //             ),
  //             tooltipBehavior: TooltipBehavior(
  //               enable: true,
  //               header: '',
  //               format: '{point.x}: \$ {point.y}',
  //               canShowMarker: true,
  //               textStyle: TextStyle(
  //                   fontSize: MediaQuery.of(context).size.width * 0.03),
  //             ),
  //             series: <CartesianSeries>[
  //               ColumnSeries<SalesData, String>(
  //                 dataSource: [
  //                   SalesData('Expenses', totalExpenses),
  //                   SalesData('Savings', totalIncome - totalExpenses),
  //                 ],
  //                 xValueMapper: (data, _) => data.month,
  //                 yValueMapper: (data, _) => data.sales,
  //                 name: 'Breakdown',
  //                 width: 0.7, // جعل الأعمدة أعرض
  //                 spacing: 0.1, // تقليل المسافة بين الأعمدة
  //                 onPointTap: (ChartPointDetails details) {
  //                   // عند الضغط على العمود يظهر قيمة الـ Tooltip
  //                   print('Tapped on ${details.pointIndex}');
  //                 },
  //                 borderRadius: BorderRadius.circular(8),
  //                 dataLabelSettings: DataLabelSettings(
  //                   isVisible: true,
  //                   labelAlignment: ChartDataLabelAlignment.outer,
  //                   textStyle: TextStyle(
  //                       fontSize: MediaQuery.of(context).size.width * 0.03,
  //                       fontWeight: FontWeight.bold),
  //                 ),
  //                 pointColorMapper: (SalesData data, _) {
  //                   // تغيير اللون حسب نوع البيانات
  //                   return data.month == 'Expenses'
  //                       ? Colors.redAccent
  //                       : Colors.greenAccent;
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding:
  //           EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.02),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             children: [
  //               _buildLegendItem(
  //                 color: Colors.greenAccent,
  //                 title: 'Total Income',
  //                 value: totalIncome,
  //               ),
  //               _buildLegendItem(
  //                 color: Colors.redAccent,
  //                 title: 'Total Expenses',
  //                 value: totalExpenses,
  //               ),
  //               _buildLegendItem(
  //                 color: Colors.blueAccent,
  //                 title: 'Net Savings',
  //                 value: totalIncome - totalExpenses,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildTransactionList() {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xfff9f9f9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
          ),
          if (_transactions.isEmpty)
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No transactions found',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            )
          else
            ..._transactions.take(5).map((transaction) => _transactionTile(
                  transaction: transaction,
                  onTap: () => _showTransactionDetails(transaction),
                )),
          if (_transactions.length > 5)
            TextButton(
              onPressed: () => _showAllTransactions(),
              child: Text(
                'View All Transactions',
                style: TextStyle(color: Colors.blue),
              ),
            ),
        ],
      ),
    );
  }

  Widget _transactionTile({
    required Map<String, dynamic> transaction,
    required VoidCallback onTap,
  }) {
    final isExpense = _isExpense(transaction);
    final amount = transaction['value'] ?? transaction['amount'] ?? 0.0;
    final icon = isExpense ? Icons.arrow_downward : Icons.arrow_upward;
    final color = isExpense ? Colors.red : Colors.green;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(
        transaction['category'] ?? transaction['source'] ?? 'Transaction',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        DateFormat('MMM dd, yyyy').format(DateTime.parse(transaction['date'])),
      ),
      trailing: Text(
        '${amount.toStringAsFixed(2)} \$',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showTransactionDetails(Map<String, dynamic> transaction) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              transaction['category'] ?? transaction['source'] ?? 'Transaction',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Amount: \$${transaction['value'] ?? transaction['amount']}'),
            Text(
                'Date: ${DateFormat.yMMMd().format(DateTime.parse(transaction['date']))}'),
            if (transaction['description'] != null)
              Text('Notes: ${transaction['description']}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAllTransactions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'All Transactions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: _transactions
                    .map((transaction) => _transactionTile(
                          transaction: transaction,
                          onTap: () => _showTransactionDetails(transaction),
                        ))
                    .toList(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(
      {required Color color, required String title, required double value}) {
    return Column(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class SalesData {
  final String month;
  final double sales;

  SalesData(this.month, this.sales);
}
