import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesservicechar {
  final SharedPreferences sharedPreferences;

  SharedPreferencesservicechar(this.sharedPreferences);

  // إضافة الرقم مع النوع إلى SharedPreferences
  Future<void> addNumber(double value, String type) async {
    final result = sharedPreferences.getStringList('items_number_CHAR') ?? [];
    result.add('$value,$type');
    await sharedPreferences.setStringList('items_number_CHAR', result);
  }

  // استرجاع الأرقام مع الأنواع من SharedPreferences
  Future<List<Map<String, dynamic>>> getNumbers() async {
    final result = sharedPreferences.getStringList('items_number_CHAR') ?? [];
    return result.map((e) {
      final parts = e.split(',');
      return {
        'value': double.tryParse(parts[0]) ?? 0.0,
        'type': parts[1],
      };
    }).toList();
  }

  // حذف رقم معين بناءً على الفهرس
  Future<void> removeNumber(int index) async {
    final result = sharedPreferences.getStringList('items_number_CHAR') ?? [];
    if (index >= 0 && index < result.length) {
      result.removeAt(index);
      await sharedPreferences.setStringList('items_number_CHAR', result);
    }
  }

  // حذف جميع الأرقام
  Future<void> removeAllNumbers() async {
    await sharedPreferences.remove('items_number_CHAR');
  }

  // تحديث رقم معين في SharedPreferences
  Future<void> updateNumber(int index, double value, String type) async {
    final result = sharedPreferences.getStringList('items_number_CHAR') ?? [];
    if (index >= 0 && index < result.length) {
      result[index] = '$value,$type';
      await sharedPreferences.setStringList('items_number_CHAR', result);
    }
  }
}
