import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/FinancialAnalysis.dart';

class SharedPreferencesServiceIncomes {
  final SharedPreferences sharedPreferences;
  SharedPreferencesServiceIncomes(this.sharedPreferences);

  Future<List<Map<String, dynamic>>> getIncomes() async {
    final result = sharedPreferences.getStringList('incomes') ?? [];
    return result.map((e) => json.decode(e) as Map<String, dynamic>).toList();
  }

  Future<void> removeIncome(int index) async {
    final result = sharedPreferences.getStringList('incomes') ?? [];
    result.removeAt(index);
    await sharedPreferences.setStringList('incomes', result);
  }

  Future<void> addIncome(Map<String, dynamic> income) async {
    final result = sharedPreferences.getStringList('incomes') ?? [];
    result.add(json.encode(income));
    await sharedPreferences.setStringList('incomes', result);
  }

  Future<List<SalesData>> getIncomesForTimePeriod(String timePeriod) async {
    List<SalesData> incomes = [];

    // جلب بيانات المداخيل من SharedPreferences
    List<String>? incomesData = sharedPreferences.getStringList('incomes');

    if (incomesData == null || incomesData.isEmpty) {
      return incomes; // إرجاع قائمة فارغة إذا كانت البيانات فارغة
    }

    for (var incomeData in incomesData) {
      try {
        if (incomeData.isNotEmpty) {
          Map<String, dynamic> income = jsonDecode(incomeData);
          if (income != null &&
              income.containsKey('value') &&
              income.containsKey('date')) {
            DateTime incomeDate = DateTime.parse(income['date']);
            bool isValid = false;

            if (timePeriod == 'Last Week') {
              isValid = DateTime.now().difference(incomeDate).inDays <= 7;
            } else if (timePeriod == 'Last Month') {
              isValid = DateTime.now().month == incomeDate.month &&
                  DateTime.now().year == incomeDate.year;
            }

            if (isValid) {
              incomes.add(SalesData(income['date'], income['value']));
            }
          }
        }
      } catch (e) {
        print("Error decoding income: $e");
      }
    }

    return incomes;
  }
}
