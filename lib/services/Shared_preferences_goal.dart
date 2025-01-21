import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesServicegoals {
  final SharedPreferences sharedPreferences;
  final String key = "goals";

  SharedPreferencesServicegoals(this.sharedPreferences);

  // Get all goals
  Future<List<Map<String, dynamic>>> getTodo() async {
    final data = sharedPreferences.getString(key);
    if (data != null) {
      return List<Map<String, dynamic>>.from(json.decode(data));
    }
    return [];
  }

  // Get a single goal by index
  Future<Map<String, dynamic>?> getSingleGoal(int index) async {
    final data = await getTodo();
    if (index >= 0 && index < data.length) {
      return data[index];
    }
    return null;
  }

  // Add a new goal
  Future<void> addGoal(Map<String, dynamic> goal) async {
    final data = await getTodo();
    data.add(goal);
    await sharedPreferences.setString(key, json.encode(data));
  }

  // Update an existing goal by index
  Future<void> updateGoal(int index, Map<String, dynamic> updatedGoal) async {
    final data = await getTodo();
    if (index >= 0 && index < data.length) {
      data[index] = updatedGoal;
      await sharedPreferences.setString(key, json.encode(data));
    }
  }

  // Remove a goal by index
  Future<void> removeTodo(int index) async {
    final data = await getTodo();
    if (index >= 0 && index < data.length) {
      data.removeAt(index);
      await sharedPreferences.setString(key, json.encode(data));
    }
  }

  // Clear all goals
  Future<void> clearAll() async {
    await sharedPreferences.remove(key);
  }
}
