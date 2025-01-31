import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:async'; // استيراد Timer

import '../compo/AppBarcom.dart';
import 'AddReminder.dart';

class Reminders extends StatefulWidget {
  static String id = "Reminders";

  @override
  State<Reminders> createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {
  List<Map<String, dynamic>> listReminders = [];
  Timer? _timer; // مؤقت لتحديث الواجهة تلقائيًا

  @override
  void initState() {
    super.initState();
    loadReminders();
    startAutoUpdate(); // تشغيل تحديث الواجهة تلقائيًا
  }

  void startAutoUpdate() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {}); // تحديث الواجهة كل ثانية لعرض الوقت المتبقي
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // إيقاف المؤقت عند مغادرة الصفحة لتوفير الموارد
    super.dispose();
  }

  void saveReminders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("reminders", json.encode(listReminders));
  }

  Future<void> loadReminders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString("reminders");
    setState(() {
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
      backgroundColor: Colors.white,
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
                  if (newIndex > oldIndex) newIndex--;
                  final item = listReminders.removeAt(oldIndex);
                  listReminders.insert(newIndex, item);
                });
                saveReminders();
              },
              itemBuilder: (context, index) {
                final reminder = listReminders[index];
                final name = reminder['name'] ?? 'Unnamed Reminder';
                final amount = reminder['amount'] ?? 0.0;
                final reminderDate =
                    DateTime.tryParse(reminder['reminderDate'] ?? '') ??
                        DateTime.now();

                final Duration remainingDuration =
                    reminderDate.difference(DateTime.now());
                final int remainingMinutes = remainingDuration.inMinutes % 60;
                final int remainingSeconds = remainingDuration.inSeconds % 60;

                return Card(
                  key: ValueKey(reminder),
                  elevation: 5,
                  color: Colors.grey[200],
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
        backgroundColor: const Color(0xFF507da0),
        child: const Icon(Icons.add, color: Colors.white),
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
