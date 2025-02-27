import 'dart:convert';
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../view/HomePage.dart';

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

  Future<void> uploadIncomesToDrive(DriveApi driveApi) async {
    final incomes = await getIncomes();
    final incomesJson = jsonEncode(incomes);

    // إنشاء Media من بيانات المداخيل
    final media =
        Media(Stream.fromIterable([incomesJson.codeUnits]), incomesJson.length);

    // إنشاء كائن File لرفع الملف
    final driveFile = drive.File()
      ..name = 'incomes.json'
      ..mimeType = 'application/json'; // تحديد نوع الميديا

    try {
      // رفع الملف إلى Google Drive
      final uploadedFile =
          await driveApi.files.create(driveFile, uploadMedia: media);
      print('File uploaded: ${uploadedFile.id}');
    } catch (e) {
      print('Error uploading file: $e');
    }
  }
}
