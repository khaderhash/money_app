import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/FinancialAnalysis.dart';

class SharedPreferencesServiceexpenses {
  final SharedPreferences sharedPreferences;
  SharedPreferencesServiceexpenses(this.sharedPreferences);

  Future<List<Map<String, dynamic>>> getExpenses() async {
    final result = sharedPreferences.getStringList('expenses') ?? [];
    return result.map((e) => json.decode(e) as Map<String, dynamic>).toList();
  }

  Future<void> removeExpense(int index) async {
    final result = sharedPreferences.getStringList('expenses') ?? [];
    result.removeAt(index);
    await sharedPreferences.setStringList('expenses', result);
  }

  Future<void> addExpense(Map<String, dynamic> expense) async {
    final result = sharedPreferences.getStringList('expenses') ?? [];
    result.add(json.encode(expense));
    await sharedPreferences.setStringList('expenses', result);
  }

  Future<List<SalesData>> getExpensesForTimePeriod(String timePeriod) async {
    List<SalesData> expenses = [];

    // جلب بيانات المصاريف من SharedPreferences
    List<String>? expensesData = sharedPreferences.getStringList('expenses');

    if (expensesData == null || expensesData.isEmpty) {
      return expenses; // إرجاع قائمة فارغة إذا كانت البيانات فارغة
    }

    for (var expenseData in expensesData) {
      try {
        if (expenseData.isNotEmpty) {
          Map<String, dynamic> expense = jsonDecode(expenseData);
          if (expense != null &&
              expense.containsKey('value') &&
              expense.containsKey('date')) {
            DateTime expenseDate = DateTime.parse(expense['date']);
            bool isValid = false;

            if (timePeriod == 'Last Week') {
              isValid = DateTime.now().difference(expenseDate).inDays <= 7;
            } else if (timePeriod == 'Last Month') {
              isValid = DateTime.now().month == expenseDate.month &&
                  DateTime.now().year == expenseDate.year;
            }

            if (isValid) {
              expenses.add(SalesData(expense['date'], expense['value']));
            }
          }
        }
      } catch (e) {
        print("Error decoding expense: $e");
      }
    }

    return expenses;
  }
}
