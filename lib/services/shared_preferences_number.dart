import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesservice {
  final SharedPreferences sharedPreferences;

  SharedPreferencesservice(this.sharedPreferences);

  Future<void> addNumber(double value) async {
    final result = sharedPreferences.getStringList('items_number');
    List<double> numbers =
        result?.map((e) => double.tryParse(e) ?? 0.0).toList() ?? [];
    numbers.add(value);
    await sharedPreferences.setStringList(
        'items_number', numbers.map((e) => e.toString()).toList());
  }

  Future<List<double>> getNumbers() async {
    final result = sharedPreferences.getStringList('items_number');
    return result?.map((e) => double.tryParse(e) ?? 0.0).toList() ?? [];
  }

  Future<void> removeNumber(int index) async {
    final result = sharedPreferences.getStringList('items_number');
    List<double> numbers =
        result?.map((e) => double.tryParse(e) ?? 0.0).toList() ?? [];
    numbers.removeAt(index);
    await sharedPreferences.setStringList(
        'items_number', numbers.map((e) => e.toString()).toList());
  }

  Future<void> updateNumber(int index, double value) async {
    final result = sharedPreferences.getStringList('items_number');
    List<double> numbers =
        result?.map((e) => double.tryParse(e) ?? 0.0).toList() ?? [];
    numbers[index] = value;
    await sharedPreferences.setStringList(
        'items_number', numbers.map((e) => e.toString()).toList());
  }
}
