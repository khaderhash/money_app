import 'package:flutter/material.dart';
import 'package:moneyappp/Screens/addtodo.dart';
import 'package:moneyappp/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/shared_preferences.dart';

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
  List<String> _list = [];
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
    _list = await servicetoaddtext?.getTodo() ?? [];
    listData.clear();
    for (var i = 0; i < _list.length; i++) {
      String data = _list[i];
      if (data.toLowerCase().contains(searchText.toLowerCase())) {
        listData.add(data);
      }
    }
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Container(
          width: width(context),
          height: 40,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: Colors.blue)),
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
                    hintText: 'search',
                    hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400),
                    contentPadding: EdgeInsets.only(
                      left: 0,
                    ),
                    focusedBorder: InputBorder.none,
                    filled: true,
                    isDense: true,
                    fillColor: Colors.transparent,
                  ),
                  style: TextStyle(fontSize: 18),
                  obscureText: false,
                ),
              )
            ],
          ),
        ),
      ),
      body: SizedBox(
        height: hight(context),
        child: ListView.builder(
          itemCount: listData.length,
          itemBuilder: (context, index) {
            return GestureDetector(
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
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      color: Colors.blue,
                    )),
                margin: EdgeInsets.only(
                  left: 20,
                  top: 10,
                  right: 20,
                  bottom: 10,
                ),
                height: 60,
                child: Row(children: [
                  Expanded(
                      child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.check,
                        color: Colors.blue,
                        size: 20,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          listData[index] ?? '',
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  )),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          servicetoaddtext?.removeTodo(index);
                        });
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.blue,
                      ),
                    ),
                  )
                ]),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Goalsadd(
              title: '',
            ),
          ));
          setState(()async {
            listDatagoals = await servicetoaddtext?.getTodo() ?? [];
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
