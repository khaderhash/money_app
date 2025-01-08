import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences sharedPreferences;
  SharedPreferencesService(this.sharedPreferences);

  Future<void> addTodo(String value) async {
    final result = sharedPreferences.getStringList('items');
    result?.add(value);
    await sharedPreferences.setStringList('items', result ?? []);
  }

  Future<List<String>> getTodo() async {
    return sharedPreferences.getStringList('items') ?? [];
  }

  Future<void> removeTodo(int index) async {
    final result = sharedPreferences.getStringList('items');
    result?.removeAt(index);
    await sharedPreferences.setStringList('items', result ?? []);
  }

  Future<void> updateTodo(int index, String value) async {
    final result = sharedPreferences.getStringList('items');
    result?.removeAt(index);
    result?.insert(index, value);
    await sharedPreferences.setStringList('items', result ?? []);
  }
}
