import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:myappmoney2/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/Shared_preferences_goal.dart';
import '../services/shared_preferences_expences.dart';
import 'Goaladd.dart';

class Goals extends StatefulWidget {
  Goals({super.key});
  static String id = "Goals";

  @override
  State<Goals> createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  List<Map<String, String>> listData = [];
  var servicetoaddtext;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  initSharedPreferences() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    servicetoaddtext = SharedPreferencesServicegoals(sharedPreferences);
    listData = await servicetoaddtext?.getTodo() ?? [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: Text('Goals'),
      ),
      body: ListView.builder(
        itemCount: listData.length,
        itemBuilder: (context, index) {
          final goal = listData[index];
          double targetAmount = double.tryParse(goal['amount'] ?? '0') ?? 0;
          double currentAmount =
              double.tryParse(goal['current_amount'] ?? '0') ?? 0;

          double progress =
              (targetAmount > 0) ? (currentAmount / targetAmount) : 0;

          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: EdgeInsets.all(15),
              title: Text(
                goal['goal'] ?? '',
              ),
              subtitle: Text(
                'Type: ${goal['type']}, Target: ${goal['amount']}, Saved: ${goal['current_amount']}',
                style: TextStyle(color: Colors.blueAccent),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.blueAccent),
                onPressed: () => deleteItem(index),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                  builder: (context) => Goalsadd(
                    title: goal['goal'],
                    index: index,
                  ),
                ))
                    .then((_) {
                  initSharedPreferences();
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (context) => Goalsadd(title: ''),
          ))
              .then((_) {
            initSharedPreferences();
          });
        },
        tooltip: 'Add Goal',
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
    );
  }

  void deleteItem(int index) async {
    setState(() {
      listData.removeAt(index);
    });
    await servicetoaddtext?.removeTodo(index);
  }
}

