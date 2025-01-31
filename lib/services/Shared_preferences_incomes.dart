// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../Screens/FinancialAnalysis.dart';
//
// class SharedPreferencesServiceIncomes {
//   final SharedPreferences sharedPreferences;
//   SharedPreferencesServiceIncomes(this.sharedPreferences);
//
//   Future<List<Map<String, dynamic>>> getIncomes() async {
//     final result = sharedPreferences.getStringList('incomes') ?? [];
//     return result.map((e) => json.decode(e) as Map<String, dynamic>).toList();
//   }
//
//   Future<void> removeIncome(int index) async {
//     final result = sharedPreferences.getStringList('incomes') ?? [];
//     result.removeAt(index);
//     await sharedPreferences.setStringList('incomes', result);
//   }
//
//   Future<void> addIncome(Map<String, dynamic> income) async {
//     final result = sharedPreferences.getStringList('incomes') ?? [];
//     result.add(json.encode(income));
//     await sharedPreferences.setStringList('incomes', result);
//   }
//
//   Future<List<SalesData>> getIncomesForTimePeriod(String timePeriod) async {
//     List<SalesData> incomes = [];
//
//     // جلب بيانات المداخيل من SharedPreferences
//     List<String>? incomesData = sharedPreferences.getStringList('incomes');
//
//     if (incomesData == null || incomesData.isEmpty) {
//       return incomes; // إرجاع قائمة فارغة إذا كانت البيانات فارغة
//     }
//
//     for (var incomeData in incomesData) {
//       try {
//         if (incomeData.isNotEmpty) {
//           Map<String, dynamic> income = jsonDecode(incomeData);
//           if (income != null &&
//               income.containsKey('value') &&
//               income.containsKey('date')) {
//             DateTime incomeDate = DateTime.parse(income['date']);
//             bool isValid = false;
//
//             if (timePeriod == 'Last Week') {
//               isValid = DateTime.now().difference(incomeDate).inDays <= 7;
//             } else if (timePeriod == 'Last Month') {
//               isValid = DateTime.now().month == incomeDate.month &&
//                   DateTime.now().year == incomeDate.year;
//             }
//
//             if (isValid) {
//               incomes.add(SalesData(income['date'], income['value']));
//             }
//           }
//         }
//       } catch (e) {
//         print("Error decoding income: $e");
//       }
//     }
//
//     return incomes;
//   }
// }
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/FinancialAnalysis.dart';
import '../Screens/HomePage.dart';

// shared_preferences_incomes.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/FinancialAnalysis.dart';
import '../Screens/HomePage.dart';

class SharedPreferencesServiceIncomes {
  final SharedPreferences sharedPreferences;
  static const String _key = 'incomes';

  SharedPreferencesServiceIncomes(this.sharedPreferences);

  Future<List<Map<String, dynamic>>> getIncomes() async {
    try {
      final data = sharedPreferences.getString(_key);
      return data != null
          ? List<Map<String, dynamic>>.from(jsonDecode(data))
          : [];
    } catch (e) {
      print("Error retrieving incomes: $e");
      return [];
    }
  }

  Future<void> _save(List<Map<String, dynamic>> data) async {
    await sharedPreferences.setString(_key, jsonEncode(data));
  }

  Future<void> addIncome(Map<String, dynamic> income) async {
    final incomes = await getIncomes();
    income['date'] = DateTime.now().toIso8601String();
    income['value'] = (income['value'] as num?)?.toDouble() ?? 0.0;
    income['source'] = income['source'] ?? 'Other';
    incomes.insert(0, income);
    await _save(incomes);
  }

  Future<void> removeIncome(int index) async {
    final incomes = await getIncomes();
    if (index >= 0 && index < incomes.length) {
      incomes.removeAt(index);
      await _save(incomes);
    }
  }

  Future<void> updateIncome(
      int index, Map<String, dynamic> updatedIncome) async {
    final incomes = await getIncomes();
    if (index >= 0 && index < incomes.length) {
      incomes[index] = updatedIncome;
      await _save(incomes);
    }
  }

  Future<List<SalesData>> getIncomesForTimePeriod(String timePeriod) async {
    final now = DateTime.now();
    final incomes = await getIncomes();
    final filtered = <SalesData>[];

    for (var income in incomes) {
      try {
        final date = DateTime.parse(income['date']);
        if (_isInPeriod(date, now, timePeriod)) {
          filtered.add(SalesData(income['source'] ?? 'Other',
              (income['value'] as num).toDouble()));
        }
      } catch (e) {
        print("Error processing income: $e");
      }
    }
    return filtered;
  }

  bool _isInPeriod(DateTime date, DateTime now, String period) {
    switch (period) {
      case 'Last Week':
        return now.difference(date).inDays <= 7;
      case 'Last Month':
        return now.month == date.month && now.year == date.year;
      case 'Last 2 Months':
        final cutoff = DateTime(now.year, now.month - 2, now.day);
        return date.isAfter(cutoff);
      default:
        return false;
    }
  }
}
