// // import 'package:flutter/material.dart';
// // import 'package:myappmoney2/constants.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import '../services/shared_preferences.dart';
// // import 'addtodo.dart';
// //
// // class Goals extends StatefulWidget {
// //   const Goals({super.key});
// //   static String id = "Goals";
// //
// //   @override
// //   State<Goals> createState() => _GoalsState();
// // }
// //
// // class _GoalsState extends State<Goals> {
// //   final saerchBartec = TextEditingController();
// //   SharedPreferencesService? servicetoaddtext;
// //   List<String> listData = [];
// //
// //   @override
// //   void initState() {
// //     initSharedPreferences();
// //     super.initState();
// //   }
// //
// //   initSharedPreferences() async {
// //     final sharedPreferences = await SharedPreferences.getInstance();
// //     servicetoaddtext = SharedPreferencesService(sharedPreferences);
// //     listData = await servicetoaddtext?.getTodo() ?? [];
// //     setState(() {});
// //   }
// //
// //   void searchOp(String searchText) async {
// //     List<String> _list = await servicetoaddtext?.getTodo() ?? [];
// //     listData.clear();
// //     for (var i = 0; i < _list.length; i++) {
// //       String data = _list[i];
// //       if (data.toLowerCase().contains(searchText.toLowerCase())) {
// //         listData.add(data);
// //       }
// //     }
// //     setState(() {});
// //   }
// //
// //   void addItem(String newItem) async {
// //     setState(() {
// //       listData.add(newItem); // إضافة العنصر إلى الواجهة
// //     });
// //     await servicetoaddtext
// //         ?.addTodo(newItem); // إضافة العنصر إلى SharedPreferences
// //     // تحديث البيانات من SharedPreferences بعد إضافة العنصر
// //     List<String> updatedList = await servicetoaddtext?.getTodo() ?? [];
// //     setState(() {
// //       listData = updatedList; // تحديث القائمة المحدثة
// //     });
// //   }
// //
// //   void deleteItem(int index) async {
// //     setState(() {
// //       listData.removeAt(index); // حذف العنصر من الواجهة
// //     });
// //     await servicetoaddtext
// //         ?.removeTodo(index); // حذف العنصر من SharedPreferences
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.black,
// //       appBar: AppBar(
// //         backgroundColor: Colors.blueAccent,
// //         elevation: 0,
// //         title: Container(
// //           width: width(context),
// //           height: 40,
// //           decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(10),
// //               boxShadow: [
// //                 BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 5)
// //               ]),
// //           child: Row(
// //             crossAxisAlignment: CrossAxisAlignment.center,
// //             children: [
// //               Padding(
// //                 padding: const EdgeInsets.all(8.0),
// //                 child: Icon(
// //                   Icons.search,
// //                   color: Colors.blue,
// //                   size: 22,
// //                 ),
// //               ),
// //               Expanded(
// //                 child: TextField(
// //                   textInputAction: TextInputAction.search,
// //                   maxLines: 1,
// //                   controller: saerchBartec,
// //                   keyboardType: TextInputType.text,
// //                   textAlignVertical: TextAlignVertical.center,
// //                   onChanged: searchOp,
// //                   decoration: InputDecoration(
// //                     border: InputBorder.none,
// //                     hintText: 'Search goals...',
// //                     hintStyle: TextStyle(
// //                         fontSize: 14,
// //                         color: Colors.grey,
// //                         fontWeight: FontWeight.w400),
// //                     contentPadding: EdgeInsets.only(left: 0),
// //                     focusedBorder: InputBorder.none,
// //                     filled: true,
// //                     isDense: true,
// //                     fillColor: Colors.transparent,
// //                   ),
// //                   style: TextStyle(fontSize: 18),
// //                   obscureText: false,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //       body: ReorderableListView(
// //         onReorder: (oldIndex, newIndex) {
// //
// //         },
// //         children: List.generate(listData.length, (index) {
// //           final item = listData[index]; // العنصر بناءً على الفهرس
// //           return GestureDetector(
// //             key: ValueKey(item), // استخدم item كمفتاح فريد
// //             onTap: () {
// //               Navigator.of(context)
// //                   .push(MaterialPageRoute(
// //                 builder: (context) => Goalsadd(
// //                   title: item, // العنوان
// //                   index: index, // الفهرس
// //                 ),
// //               ))
// //                   .then((_) {
// //                 initSharedPreferences(); // إعادة تحميل البيانات بعد العودة من شاشة إضافة الهدف
// //               });
// //             },
// //             child: Container(
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.circular(12),
// //                 border: Border.all(width: 1, color: Colors.blueAccent),
// //                 boxShadow: [
// //                   BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)
// //                 ],
// //               ),
// //               margin: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
// //               height: 70,
// //               child: Row(
// //                 children: [
// //                   Expanded(
// //                     child: Row(
// //                       children: [
// //                         Icon(Icons.list),
// //                         SizedBox(width: 10),
// //                         Expanded(
// //                           child: Text(
// //                             item, // العنوان
// //                             overflow: TextOverflow.ellipsis,
// //                             style: TextStyle(
// //                               fontSize: 16,
// //                               fontWeight: FontWeight.bold,
// //                               color: Colors.black,
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   Padding(
// //                     padding: const EdgeInsets.all(15.0),
// //                     child: GestureDetector(
// //                       onTap: () {
// //                         deleteItem(index); // حذف العنصر بناءً على الفهرس
// //                       },
// //                       child: Icon(
// //                         Icons.delete,
// //                         color: Colors.blueAccent,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           );
// //         }),
// //
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () async {
// //           Navigator.of(context)
// //               .push(MaterialPageRoute(
// //             builder: (context) => Goalsadd(
// //               title: '',
// //             ),
// //           ))
// //               .then((_) {
// //             // تحديث القائمة بعد العودة من شاشة إضافة الهدف
// //             initSharedPreferences(); // تحميل البيانات المحدثة
// //           });
// //         },
// //         tooltip: 'Add Goal',
// //         backgroundColor: Colors.blueAccent,
// //         child: Icon(Icons.add),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:myappmoney2/constants.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../services/shared_preferences.dart';
// import 'addtodo.dart';
//
// class Goals extends StatefulWidget {
//   const Goals({super.key});
//   static String id = "Goals";
//
//   @override
//   State<Goals> createState() => _GoalsState();
// }
//
// class _GoalsState extends State<Goals> {
//   final saerchBartec = TextEditingController();
//   SharedPreferencesService? servicetoaddtext;
//   List<String> listData = [];
//
//   @override
//   void initState() {
//     initSharedPreferences();
//     super.initState();
//   }
//
//   initSharedPreferences() async {
//     final sharedPreferences = await SharedPreferences.getInstance();
//     servicetoaddtext = SharedPreferencesService(sharedPreferences);
//     listData = await servicetoaddtext?.getTodo() ?? [];
//     setState(() {});
//   }
//
//   void searchOp(String searchText) async {
//     List<String> _list = await servicetoaddtext?.getTodo() ?? [];
//     listData.clear();
//     for (var i = 0; i < _list.length; i++) {
//       String data = _list[i];
//       if (data.toLowerCase().contains(searchText.toLowerCase())) {
//         listData.add(data);
//       }
//     }
//     setState(() {});
//   }
//
//   void addItem(String newItem) async {
//     setState(() {
//       listData.add(newItem); // إضافة العنصر إلى الواجهة
//     });
//     await servicetoaddtext
//         ?.addTodo(newItem); // إضافة العنصر إلى SharedPreferences
//     // تحديث البيانات من SharedPreferences بعد إضافة العنصر
//     List<String> updatedList = await servicetoaddtext?.getTodo() ?? [];
//     setState(() {
//       listData = updatedList; // تحديث القائمة المحدثة
//     });
//   }
//
//   void deleteItem(int index) async {
//     setState(() {
//       listData.removeAt(index); // حذف العنصر من الواجهة
//     });
//     await servicetoaddtext
//         ?.removeTodo(index); // حذف العنصر من SharedPreferences
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.blueAccent,
//         elevation: 0,
//         title: Container(
//           width: width(context),
//           height: 40,
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 5)
//               ]),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Icon(
//                   Icons.search,
//                   color: Colors.blue,
//                   size: 22,
//                 ),
//               ),
//               Expanded(
//                 child: TextField(
//                   textInputAction: TextInputAction.search,
//                   maxLines: 1,
//                   controller: saerchBartec,
//                   keyboardType: TextInputType.text,
//                   textAlignVertical: TextAlignVertical.center,
//                   onChanged: searchOp,
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     hintText: 'Search goals...',
//                     hintStyle: TextStyle(
//                         fontSize: 14,
//                         color: Colors.grey,
//                         fontWeight: FontWeight.w400),
//                     contentPadding: EdgeInsets.only(left: 0),
//                     focusedBorder: InputBorder.none,
//                     filled: true,
//                     isDense: true,
//                     fillColor: Colors.transparent,
//                   ),
//                   style: TextStyle(fontSize: 18),
//                   obscureText: false,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: ReorderableListView(
//         onReorder: (oldIndex, newIndex) {
//
//         },
//         children:[
//           for(int index = 0; index < listData.length; index++)
//             Card(
//               key: ValueKey(listData[index]),
//               elevation: 5,
//               child: GestureDetector(
//                 key: ValueKey(listData[index]), // استخدم item كمفتاح فريد
//                 onTap: () {
//                   Navigator.of(context)
//                       .push(MaterialPageRoute(
//                     builder: (context) => Goalsadd(
//                       title: listData[index], // العنوان
//                       index: index, // الفهرس
//                     ),
//                   ))
//                       .then((_) {
//                     initSharedPreferences(); // إعادة تحميل البيانات بعد العودة من شاشة إضافة الهدف
//                   });
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(width: 1, color: Colors.blueAccent),
//                     boxShadow: [
//                       BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)
//                     ],
//                   ),
//                   margin: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
//                   height: 70,
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Row(
//                           children: [
//                             Icon(Icons.list),
//                             SizedBox(width: 10),
//                             Expanded(
//                               child: Text(
//                                 listData[index], // العنوان
//                                 overflow: TextOverflow.ellipsis,
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(15.0),
//                         child: GestureDetector(
//                           onTap: () {
//                             deleteItem(index); // حذف العنصر بناءً على الفهرس
//                           },
//                           child: Icon(
//                             Icons.delete,
//                             color: Colors.blueAccent,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//         ]
//
//
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           Navigator.of(context)
//               .push(MaterialPageRoute(
//             builder: (context) => Goalsadd(
//               title: '',
//             ),
//           ))
//               .then((_) {
//             // تحديث القائمة بعد العودة من شاشة إضافة الهدف
//             initSharedPreferences(); // تحميل البيانات المحدثة
//           });
//         },
//         tooltip: 'Add Goal',
//         backgroundColor: Colors.blueAccent,
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:implicitly_animated_reorderable_list/transitions.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:myappmoney2/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/shared_preferences.dart';
import 'addtodo.dart';

class Goals extends StatefulWidget {
  const Goals({super.key});
  static String id = "Goals";

  @override
  State<Goals> createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  final saerchBartec = TextEditingController();
  SharedPreferencesService? servicetoaddtext;
  List<String> listData = [];

  @override
  void initState() {
    initSharedPreferences();
    super.initState();
  }

  initSharedPreferences() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    servicetoaddtext = SharedPreferencesService(sharedPreferences);
    listData = await servicetoaddtext?.getTodo() ?? [];
    setState(() {});
  }

  void searchOp(String searchText) async {
    List<String> _list = await servicetoaddtext?.getTodo() ?? [];
    listData.clear();
    for (var i = 0; i < _list.length; i++) {
      String data = _list[i];
      if (data.toLowerCase().contains(searchText.toLowerCase())) {
        listData.add(data);
      }
    }
    setState(() {});
  }

  void addItem(String newItem) async {
    setState(() {
      listData.add(newItem);
    });
    await servicetoaddtext?.addTodo(newItem);
    List<String> updatedList = await servicetoaddtext?.getTodo() ?? [];
    setState(() {
      listData = updatedList;
    });
  }

  void deleteItem(int index) async {
    setState(() {
      listData.removeAt(index);
    });
    await servicetoaddtext?.removeTodo(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: Container(
          width: width(context),
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 5),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.search,
                  color: Colors.blue,
                  size: 22,
                ),
              ),
              Expanded(
                child: TextField(
                  textInputAction: TextInputAction.search,
                  maxLines: 1,
                  controller: saerchBartec,
                  keyboardType: TextInputType.text,
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: searchOp,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search goals...',
                    hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400),
                    contentPadding: EdgeInsets.only(left: 0),
                    focusedBorder: InputBorder.none,
                    filled: true,
                    isDense: true,
                    fillColor: Colors.transparent,
                  ),
                  style: TextStyle(fontSize: 18),
                  obscureText: false,
                ),
              ),
            ],
          ),
        ),
      ),
      body: ImplicitlyAnimatedReorderableList<String>(
        items: listData,
        areItemsTheSame: (oldItem, newItem) => oldItem == newItem,
        onReorderFinished: (item, from, to, newItems) async {
          setState(() {
            listData = newItems;
          });
          // تحديث البيانات في SharedPreferences
          await servicetoaddtext?.setTodoList(listData);
        },
        itemBuilder: (context, itemAnimation, item, index) {
          return Reorderable(
            key: ValueKey(item),
            builder: (context, dragAnimation, inDrag) {
              return SizeFadeTransition(
                animation: itemAnimation,
                child: Card(
                  elevation: 5,
                  child: ListTile(
                    title: Text(
                      item,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.blueAccent),
                      onPressed: () => deleteItem(index),
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                        builder: (context) => Goalsadd(
                          title: item,
                          index: index,
                        ),
                      ))
                          .then((_) {
                        initSharedPreferences();
                      });
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (context) => Goalsadd(
              title: '',
            ),
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
}
