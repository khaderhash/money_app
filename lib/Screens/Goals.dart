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
        shrinkWrap: true,
        removeDuration: const Duration(),
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
              return ScaleTransition(
                scale:
                    Tween<double>(begin: 1, end: 0.95).animate(dragAnimation),
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
