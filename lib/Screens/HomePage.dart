// homepage.dart
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
import 'Expences.dart';
import 'FinancialAnalysis.dart';
import 'Goals.dart';
import 'Incomes.dart';
import 'Reminders.dart';
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
      ..removeWhere((t) => t['date'] == null) // أضف هذا السطر
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
      height: height * 0.44,
      child: Stack(
        children: [
          ClipPath(
            clipper: OutSideCustomShape(),
            child: Container(
              width: width,
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
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: hight(context) * 0.05),
              child: Image.asset(
                'assets/photo/khaderlogo2.png',
                width: width * 0.7,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialAnalysis() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
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
          Text(
            'Financial Difference: ${(totalIncome - totalExpenses).toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: totalIncome >= totalExpenses ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 20),
          if (totalExpenses > 0 || totalIncome > 0) ...[
            _buildPieChart(),
            _buildBarChart(),
          ],
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return SfCircularChart(
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
    );
  }

  Widget _buildBarChart() {
    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(),
      primaryYAxis: const NumericAxis(),
      legend: const Legend(isVisible: true),
      series: <CartesianSeries>[
        ColumnSeries<SalesData, String>(
          dataSource: [SalesData('Expenses', totalExpenses)],
          xValueMapper: (data, _) => data.month,
          yValueMapper: (data, _) => data.sales,
          name: 'Expenses',
          color: Colors.red,
        ),
        ColumnSeries<SalesData, String>(
          dataSource: [SalesData('Income', totalIncome)],
          xValueMapper: (data, _) => data.month,
          yValueMapper: (data, _) => data.sales,
          name: 'Income',
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildTransactionList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Transactions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _getAllTransactions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) =>
                    _transactionTile(snapshot.data![index]),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _transactionTile(Map<String, dynamic> transaction) {
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
    );
  }
}

class SalesData {
  final String month;
  final double sales;

  SalesData(this.month, this.sales);
}
//import 'package:flutter/material.dart';
// import 'package:myappmoney2/Screens/Goals.dart';
// import 'package:myappmoney2/compo/drawer.dart';
// import 'package:myappmoney2/constants.dart';
// import '../compo/clickHomepage.dart';
// import '../compo/outsidecs.dart';
// import 'package:myappmoney2/Screens/Expences.dart';
// import 'Incomes.dart';
// import 'FinancialAnalysis.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'Reminders.dart';
// import 'login.dart';
//
// class Homepage extends StatefulWidget {
//   const Homepage({super.key});
//   static String id = "homepage";
//
//   @override
//   _HomepageState createState() => _HomepageState();
// }
//
// class _HomepageState extends State<Homepage> {
//   @override
//   void initState() {
//     super.initState();
//     checkLoginStatus();
//   }
//
//   void checkLoginStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     bool? isLoggedIn = prefs.getBool('isLoggedIn');
//
//     if (isLoggedIn == false || isLoggedIn == null) {
//       Navigator.pushReplacementNamed(context, loginpage.id);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: DrawerClass(
//         accountName: 'khader',
//         accountEmail: 'khader@gmail',
//         accountInitial: 'ksfh',
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           final screenHeight = constraints.maxHeight;
//
//           final screenWidth = constraints.maxWidth;
//
//           return Stack(
//             children: [
//               Positioned.fill(
//                 child: Column(
//                   children: [
//                     Expanded(
//                       child: Container(color: Color(0xFFF5F5F5)),
//                     ),
//                   ],
//                 ),
//               ),
//               // Curved Divider (Modified to Half Circle)
//               Positioned(
//                 top: 0,
//                 child: Container(
//                   width: screenWidth,
//                   alignment: Alignment.center,
//                   child: ClipPath(
//                     clipper: OutSideCustomShape(),
//                     child: Container(
//                       width: screenWidth,
//                       height: screenHeight * 0.44,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: const Color(0xFF482F37),
//                           width: 2,
//                         ),
//                         gradient: const LinearGradient(
//                           colors: [Color(0xFF2e495e), Color(0xFF507da0)],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: const Color(0xFF482F37),
//                             blurRadius: 3,
//                             offset: const Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               // Rotated Logo
//               Positioned(
//                 top: screenHeight * 0.1,
//                 left: screenWidth * 0.17,
//                 child: Transform.rotate(
//                   angle: 0,
//                   child: Container(
//                     height: hight(context) * .2,
//                     width: screenWidth * 0.7,
//                     child: Image.asset(
//                       'assets/photo/khaderlogo2.png',
//                       fit: BoxFit.fitWidth,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: 0,
//                 child: Container(
//                   width: screenWidth,
//                   height: screenHeight * 0.56,
//                   color: Color(0xFFF5F5F5),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 36.0),
//                     child: ListView(
//                       children: [
//                         SizedBox(height: 20),
//                         ButtonHome(
//                           ontap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => IncomesScreens()));
//                           },
//                           name: 'Incomes',
//                         ),
//                         const SizedBox(height: 8),
//                         ButtonHome(
//                           ontap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => ExpencesScreens()));
//                           },
//                           name: 'Expences',
//                         ),
//                         const SizedBox(height: 8),
//                         ButtonHome(
//                           ontap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => Goals()));
//                           },
//                           name: 'Goals',
//                         ),
//                         const SizedBox(height: 8),
//                         ButtonHome(
//                           ontap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => Reminders()));
//                           },
//                           name: 'Reminders',
//                         ),
//                         const SizedBox(height: 8),
//                         ButtonHome(
//                           ontap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => Financialanalysis()));
//                           },
//                           name: 'Analysis money',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }