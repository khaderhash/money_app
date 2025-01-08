import 'package:flutter/material.dart';
import 'package:moneyappp/Screens/addtodo.dart';
import 'package:moneyappp/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/shared_preferences.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  static String id = "Expenses";

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final saerchBarTec = TextEditingController();
  SharedPreferencesService? service;
  List<String> listData = [];
  List<String> _list = [];
  @override
  void initState() {
    initSharedPreferences();
    super.initState();
  }

  initSharedPreferences() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    service = SharedPreferencesService(sharedPreferences);
    listData = await service?.getTodo() ?? [];
    setState(() {});
  }

  void searchOp(String searchText) async {
    _list = await service?.getTodo() ?? [];
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
        backgroundColor: Colors.white,
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
                  controller: saerchBarTec,
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
                  builder: (context) => AddTodoScreen(
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
                          service?.removeTodo(index);
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
            builder: (context) => AddTodoScreen(
              title: '',
            ),
          ));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
