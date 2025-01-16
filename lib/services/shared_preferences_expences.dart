import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesServiceexpenses {
  final SharedPreferences sharedPreferences;
  SharedPreferencesServiceexpenses(this.sharedPreferences);
  Future<void> addExpense(Map<String, dynamic> expense) async {
    final result = sharedPreferences.getStringList('expenses') ?? [];
    result.add(json.encode(expense));
    await sharedPreferences.setStringList('expenses', result);
  }

  Future<List<Map<String, dynamic>>> getExpenses() async {
    final result = sharedPreferences.getStringList('expenses') ?? [];
    return result.map((e) => json.decode(e) as Map<String, dynamic>).toList();
  }

  Future<void> removeExpense(int index) async {
    final result = sharedPreferences.getStringList('expenses') ?? [];
    result.removeAt(index);
    await sharedPreferences.setStringList('expenses', result);
  }

}
