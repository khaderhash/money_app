import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences sharedPreferences;
  SharedPreferencesService(this.sharedPreferences);

  Future<void> addTodo(Map<String, String> goalData) async {
    final result = sharedPreferences.getStringList('items_String') ?? [];
    result.add(json.encode(goalData));
    await sharedPreferences.setStringList('items_String', result);
  }

  Future<List<Map<String, String>>> getTodo() async {
    List<String> storedData = sharedPreferences.getStringList('items_String') ?? [];
    List<Map<String, String>> goals = [];

    for (var item in storedData) {
      goals.add(Map<String, String>.from(json.decode(item)));
    }

    return goals;
  }

  Future<void> removeTodo(int index) async {
    final result = sharedPreferences.getStringList('items_String') ?? [];
    result.removeAt(index);
    await sharedPreferences.setStringList('items_String', result);
  }

  Future<void> updateTodo(int index, Map<String, String> updatedGoal) async {
    final result = sharedPreferences.getStringList('items_String') ?? [];
    result[index] = json.encode(updatedGoal);
    await sharedPreferences.setStringList('items_String', result);
  }

  Future<void> setTodoList(List<Map<String, String>> todoList) async {
    List<String> encodedList = todoList.map((goal) => json.encode(goal)).toList();
    await sharedPreferences.setStringList('items_String', encodedList);
  }
}
