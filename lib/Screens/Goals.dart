import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:myappmoney2/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/shared_preferences.dart';
import 'addtodo.dart';

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
    servicetoaddtext = SharedPreferencesService(sharedPreferences);
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
          double currentAmount = double.tryParse(goal['current_amount'] ?? '0') ?? 0;

          double progress = (targetAmount > 0) ? (currentAmount / targetAmount) : 0;

          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: EdgeInsets.all(15),

              title: Text(goal['goal'] ?? '',),
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
//import 'package:flutter/material.dart';
//
// class _GoalsState extends State<Goals> {
//   List<Map<String, String>> listData = [];
//
//   @override
//   void initState() {
//     super.initState();
//     initSharedPreferences();
//   }
//
//   initSharedPreferences() async {
//     final sharedPreferences = await SharedPreferences.getInstance();
//     servicetoaddtext = SharedPreferencesService(sharedPreferences);
//     listData = await servicetoaddtext?.getTodo() ?? [];
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.blueAccent,
//         elevation: 0,
//         title: Text('Goals'),
//       ),
//       body: ListView.builder(
//         itemCount: listData.length,
//         itemBuilder: (context, index) {
//           final goal = listData[index];
//           double targetAmount = double.tryParse(goal['amount'] ?? '0') ?? 0;
//           double currentAmount = double.tryParse(goal['current_amount'] ?? '0') ?? 0;
//
//           double progress = (targetAmount > 0) ? (currentAmount / targetAmount) : 0;
//
//           return Card(
//             elevation: 5,
//             margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             child: ListTile(
//               contentPadding: EdgeInsets.all(15),
//               title: Text(
//                 goal['goal'] ?? '',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueAccent),
//               ),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 10),
//                   Text(
//                     'Type: ${goal['type'] ?? 'Not specified'}',
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     'Target: ${goal['amount']}',
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     'Saved: ${goal['current_amount']}',
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),
//                   SizedBox(height: 10),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: LinearProgressIndicator(
//                           value: progress,
//                           backgroundColor: Colors.grey[300],
//                           valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       Text('${(progress * 100).toStringAsFixed(1)}%', style: TextStyle(color: Colors.blueAccent)),
//                     ],
//                   ),
//                 ],
//               ),
//               trailing: IconButton(
//                 icon: Icon(Icons.delete, color: Colors.blueAccent),
//                 onPressed: () => deleteItem(index),
//               ),
//               onTap: () {
//                 Navigator.of(context)
//                     .push(MaterialPageRoute(
//                       builder: (context) => Goalsadd(
//                         title: goal['goal'],
//                         index: index,
//                       ),
//                     ))
//                     .then((_) {
//                   initSharedPreferences();
//                 });
//               },
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           Navigator.of(context)
//               .push(MaterialPageRoute(
//                 builder: (context) => Goalsadd(title: ''),
//               ))
//               .then((_) {
//             initSharedPreferences();
//           });
//         },
//         tooltip: 'Add Goal',
//         backgroundColor: Colors.blueAccent,
//         child: Icon(Icons.add),
//       ),
//     );
//   }
//
//   void deleteItem(int index) async {
//     setState(() {
//       listData.removeAt(index);
//     });
//     await servicetoaddtext?.removeTodo(index);
//   }
// }