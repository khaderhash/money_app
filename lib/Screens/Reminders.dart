import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import '../compo/AppBarcom.dart';
import 'AddReminder.dart';

class Reminders extends StatefulWidget {
  static String id = "Reminders";

  @override
  State<Reminders> createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {
  List<Map<String, dynamic>> listReminders = [];

  @override
  void initState() {
    super.initState();
    loadReminders();
  }

  void saveReminders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("reminders", json.encode(listReminders));
  }

  Future<void> loadReminders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString("reminders");
    setState(() {
      // ضمان أن البيانات ليست null وتعيين قائمة فارغة إذا كانت null
      listReminders = data != null
          ? List<Map<String, dynamic>>.from(json.decode(data))
          : [];
    });
  }

  void updateRemindersList() async {
    await loadReminders();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: Appbarofpage(TextPage: "Reminders"),
      body: listReminders.isEmpty
          ? const Center(
              child: Text(
                'No reminders added yet!',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            )
          : ReorderableListView.builder(
              itemCount: listReminders.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex)
                    newIndex--; // تعديل الفهرس عند التحريك للأسفل
                  final item = listReminders.removeAt(oldIndex);
                  listReminders.insert(newIndex, item);
                });
                saveReminders(); // تحديث SharedPreferences بعد إعادة الترتيب
              },
              itemBuilder: (context, index) {
                final reminder = listReminders[index];
                final name = reminder['name'] ??
                    'Unnamed Reminder'; // إرجاع قيمة افتراضية إذا كانت null
                final amount = reminder['amount'] ??
                    0.0; // إرجاع قيمة افتراضية إذا كانت null
                final reminderDate =
                    DateTime.tryParse(reminder['reminderDate'] ?? '') ??
                        DateTime.now(); // إرجاع قيمة افتراضية إذا كانت null

                final Duration remainingDuration =
                    reminderDate.difference(DateTime.now());
                final int remainingMinutes = remainingDuration.inMinutes % 60;
                final int remainingSeconds = remainingDuration.inSeconds % 60;

                return Card(
                  key: ValueKey(reminder), // مفتاح لتعريف العنصر في القائمة
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text(
                      name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Amount: ${currencyFormat.format(amount)}\n'
                      'Due in: ${remainingDuration.inDays} days, '
                      '${remainingMinutes} minutes, '
                      '${remainingSeconds} seconds\n'
                      'At: ${DateFormat('yyyy-MM-dd HH:mm').format(reminderDate)}',
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Color(0xFF264653)),
                      onPressed: () => deleteReminder(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                builder: (context) =>
                    AddReminderScreen(onReminderAdded: updateRemindersList),
              ))
              .then((_) => updateRemindersList());
        },
        tooltip: 'Add Reminder',
        backgroundColor: const Color(0xFF0A84FF),
        child: const Icon(Icons.add),
      ),
    );
  }

  void deleteReminder(int index) async {
    setState(() {
      listReminders.removeAt(index);
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("reminders", json.encode(listReminders));
  }
}
