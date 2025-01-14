import 'package:flutter/material.dart';
import 'package:myappmoney2/Screens/addtodo.dart';
import 'package:myappmoney2/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myappmoney2/services/shared_preferences_number.dart';
import '../services/shared_preferences.dart';
import 'numberadd.dart';

class NumberScreen extends StatefulWidget {
  const NumberScreen({super.key});
  static String id = "NumberScreen";

  @override
  State<NumberScreen> createState() => _ExpensesState();
}

class _ExpensesState extends State<NumberScreen> {
  final saerchBarTec = TextEditingController();
  SharedPreferencesservice? servicetoaddnumber;
  List<double> listDatanumber = [];
  List<double> _listnumber = [];

  @override
  void initState() {
    initSharedPreferences();
    super.initState();
  }

  initSharedPreferences() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    servicetoaddnumber = SharedPreferencesservice(sharedPreferences);
    listDatanumber = await servicetoaddnumber?.getNumbers() ?? [];
    setState(() {});
  }

  void searchOp(String searchText) async {
    _listnumber = await servicetoaddnumber?.getNumbers() ?? [];
    listDatanumber.clear();
    for (var value in _listnumber) {
      if (value.toString().contains(searchText)) {
        listDatanumber.add(value);
      }
    }
    setState(() {});
  }

  @override
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
          itemCount: listDatanumber.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => addnumber(
                    title: listDatanumber[index].toString(),
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
                  ),
                ),
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
                          listDatanumber[index].toString(),
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
                          servicetoaddnumber?.removeNumber(index);
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
        onPressed: () async {
          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (context) => addnumber(
          //     title: '',
          //   ),
          // )
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => addnumber(
              title: '',
            ),
          ));
          listDatanumber = await servicetoaddnumber?.getNumbers() ?? [];
          setState(() async {});
        },
        tooltip: 'Add Number',
        child: Icon(Icons.add),
      ),
    );
  }
}
