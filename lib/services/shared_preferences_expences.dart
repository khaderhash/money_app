import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/FinancialAnalysis.dart';

class SharedPreferencesServiceexpenses {
  final SharedPreferences sharedPreferences;

  SharedPreferencesServiceexpenses(this.sharedPreferences);

  Future<List<Map<String, dynamic>>> getExpenses() async {
    try {
      final data = sharedPreferences.getString('expenses');
      if (data == null) return [];
      return List<Map<String, dynamic>>.from(jsonDecode(data));
    } catch (e) {
      print("Error retrieving expenses: $e");
      return [];
    }
  }

  Future<void> saveExpenses(List<Map<String, dynamic>> expenses) async {
    try {
      final data = jsonEncode(expenses);
      await sharedPreferences.setString('expenses', data);
    } catch (e) {
      print("Error saving expenses: $e");
    }
  }

  Future<void> addExpense(Map<String, dynamic> expense) async {
    final expenses = await getExpenses();
    expense['date'] = DateTime.now().toIso8601String(); // إضافة التاريخ
    expenses.insert(0, expense); // أضف المصروف في البداية
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
    List<SalesData> expenses = [];
    final currentExpenses = await getExpenses();
    final now = DateTime.now();

    for (var expense in currentExpenses) {
      try {
        final date = DateTime.parse(expense['date']);
        bool isValid = false;

        if (timePeriod == 'Last Week') {
          isValid = now.difference(date).inDays <= 7;
        } else if (timePeriod == 'Last Month') {
          isValid = now.month == date.month && now.year == date.year;
        }

        if (isValid) {
          expenses.add(SalesData(expense['date'], expense['value']));
        }
      } catch (e) {
        print("Error processing expense: $e");
      }
    }

    return expenses;
  }

  Future<void> cleanOldExpenses(Duration duration) async {
    final expenses = await getExpenses();
    final now = DateTime.now();
    expenses.removeWhere((expense) {
      final date = DateTime.parse(expense['date']);
      return now.difference(date) > duration;
    });
    await saveExpenses(expenses);
  }
}
