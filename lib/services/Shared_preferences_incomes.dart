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

class SharedPreferencesServiceIncomes {
  final SharedPreferences sharedPreferences;

  SharedPreferencesServiceIncomes(this.sharedPreferences);

  Future<List<Map<String, dynamic>>> getIncomes() async {
    try {
      final data = sharedPreferences.getString('incomes');
      if (data == null || data.isEmpty) return [];
      return List<Map<String, dynamic>>.from(jsonDecode(data));
    } catch (e) {
      print("Error retrieving incomes: $e");
      return [];
    }
  }

  Future<void> saveIncomes(List<Map<String, dynamic>> incomes) async {
    try {
      final data = jsonEncode(incomes);
      await sharedPreferences.setString('incomes', data);
    } catch (e) {
      print("Error saving incomes: $e");
    }
  }

  Future<void> addIncome(Map<String, dynamic> income) async {
    final incomes = await getIncomes();
    income['date'] = DateTime.now().toIso8601String(); // إضافة التاريخ
    incomes.insert(0, income); // إضافة الدخل في بداية القائمة
    await saveIncomes(incomes);
  }

  Future<void> removeIncome(int index) async {
    final incomes = await getIncomes();
    if (index >= 0 && index < incomes.length) {
      incomes.removeAt(index);
      await saveIncomes(incomes);
    }
  }

  Future<void> updateIncome(
      int index, Map<String, dynamic> updatedIncome) async {
    final incomes = await getIncomes();
    if (index >= 0 && index < incomes.length) {
      incomes[index] = updatedIncome;
      await saveIncomes(incomes);
    }
  }

  Future<List<SalesData>> getIncomesForTimePeriod(String timePeriod) async {
    List<SalesData> incomes = [];
    final currentIncomes = await getIncomes();
    final now = DateTime.now();

    for (var income in currentIncomes) {
      try {
        final date = DateTime.parse(income['date']);
        bool isValid = false;

        if (timePeriod == 'Last Week') {
          isValid = now.difference(date).inDays <= 7;
        } else if (timePeriod == 'Last Month') {
          isValid = now.month == date.month && now.year == date.year;
        }

        if (isValid) {
          incomes.add(SalesData(income['date'], income['value']));
        }
      } catch (e) {
        print("Error processing income: $e");
      }
    }

    return incomes;
  }

  Future<void> cleanOldIncomes(Duration duration) async {
    final incomes = await getIncomes();
    final now = DateTime.now();
    incomes.removeWhere((income) {
      final date = DateTime.parse(income['date']);
      return now.difference(date) > duration;
    });
    await saveIncomes(incomes);
  }
}
