import 'package:flutter/material.dart';
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
      listData.add(newItem); // إضافة العنصر إلى الواجهة
    });
    await servicetoaddtext
        ?.addTodo(newItem); // إضافة العنصر إلى SharedPreferences
    // تحديث البيانات من SharedPreferences بعد إضافة العنصر
    List<String> updatedList = await servicetoaddtext?.getTodo() ?? [];
    setState(() {
      listData = updatedList; // تحديث القائمة المحدثة
    });
  }

  void deleteItem(int index) async {
    setState(() {
      listData.removeAt(index); // حذف العنصر من الواجهة
    });
    await servicetoaddtext
        ?.removeTodo(index); // حذف العنصر من SharedPreferences
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 5)
              ]),
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
      body: SizedBox(
        height: hight(context),
        child: ReorderableListView(
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final item = listData.removeAt(oldIndex);
              listData.insert(newIndex, item); // تحريك العنصر
            });
            // تحديث SharedPreferences بعد إعادة ترتيب العناصر
            servicetoaddtext?.setTodoList(listData);
          },
          children: List.generate(listData.length, (index) {
            return GestureDetector(
              key: ValueKey(index),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Goalsadd(
                    title: listData[index],
                    index: index,
                  ),
                ));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 1,
                    color: Colors.blueAccent,
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.1), blurRadius: 5)
                  ],
                ),
                margin:
                    EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 10),
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              listData[index],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: GestureDetector(
                        onTap: () {
                          deleteItem(index); // حذف العنصر
                        },
                        child: Icon(
                          Icons.delete,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
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
            // تحديث القائمة بعد العودة من شاشة إضافة الهدف
            initSharedPreferences(); // تحميل البيانات المحدثة
          });
        },
        tooltip: 'Add Goal',
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
    );
  }
}
