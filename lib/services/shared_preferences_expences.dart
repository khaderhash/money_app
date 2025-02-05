import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../view/FinancialAnalysis.dart';
import '../view/HomePage.dart';

class SharedPreferencesServiceexpenses {
  final SharedPreferences sharedPreferences;
  static const String _key = 'expenses';

  SharedPreferencesServiceexpenses(this.sharedPreferences);

  Future<List<Map<String, dynamic>>> getExpenses() async {
    try {
      final data = sharedPreferences.getString(_key);
      return data != null
          ? List<Map<String, dynamic>>.from(jsonDecode(data))
          : [];
    } catch (e) {
      print("Error retrieving expenses: $e");
      return [];
    }
  }

  Future<void> saveExpenses(List<Map<String, dynamic>> data) async {
    await sharedPreferences.setString(_key, jsonEncode(data));
  }

  Future<void> addExpense(Map<String, dynamic> expense) async {
    final expenses = await getExpenses();
    expense['date'] = DateTime.now().toIso8601String();
    expense['type'] = 'Expense'; // إضافة حقل النوع
    expenses.insert(0, expense);
    await saveExpenses(expenses);
  }

  Future<void> removeExpense(int index) async {
    final expenses = await getExpenses();
    if (index >= 0 && index < expenses.length) {
      expenses.removeAt(index);
      await saveExpenses(expenses);
    }
  }

  Future<void> updateExpense(
      int index, Map<String, dynamic> updatedExpense) async {
    final expenses = await getExpenses();
    if (index >= 0 && index < expenses.length) {
      expenses[index] = updatedExpense;
      await saveExpenses(expenses);
    }
  }

  Future<List<SalesData>> getExpensesForTimePeriod(String timePeriod) async {
    final now = DateTime.now();
    final expenses = await getExpenses();
    final filtered = <SalesData>[];

    for (var expense in expenses) {
      try {
        final date = DateTime.parse(expense['date']);
        if (_isInPeriod(date, now, timePeriod)) {
          filtered.add(SalesData(expense['category'] ?? 'Uncategorized',
              (expense['value'] as num).toDouble()));
        }
      } catch (e) {
        print("Error processing expense: $e");
      }
    }

    print("Filtered Expenses: ${filtered.length}"); // Debugging
    return filtered;
  }

  bool _isInPeriod(DateTime date, DateTime now, String period) {
    switch (period) {
      case 'Last Week':
        return now.difference(date).inDays <= 7;
      case 'Last Month':
        return date.year == now.year && date.month == now.month;
      case 'Last 2 Months':
        final cutoff = DateTime(now.year, now.month - 1, 1);
        return date.isAfter(cutoff);
      default:
        return false;
    }
  }
}
