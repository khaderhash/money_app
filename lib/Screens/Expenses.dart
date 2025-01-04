import 'package:flutter/material.dart';

class Expenses extends StatelessWidget {
  const Expenses({super.key});
  static String id = "ExpensesPage";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(),
    );
  }
}
