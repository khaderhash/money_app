import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences sharedPreferences;
  SharedPreferencesService(this.sharedPreferences);

  Future<void> addTodo(String value) async {
    final result = sharedPreferences.getStringList('items_String');
    result?.add(value);
    await sharedPreferences.setStringList('items_String', result ?? []);
  }

  Future<List<String>> getTodo() async {
    return sharedPreferences.getStringList('items_String') ?? [];
  }

  Future<void> removeTodo(int index) async {
    final result = sharedPreferences.getStringList('items_String');
    result?.removeAt(index);
    await sharedPreferences.setStringList('items_String', result ?? []);
  }

  Future<void> updateTodo(int index, String value) async {
    final result = sharedPreferences.getStringList('items_String');
    result?.removeAt(index);
    result?.insert(index, value);
    await sharedPreferences.setStringList('items_String', result ?? []);
  }
}
