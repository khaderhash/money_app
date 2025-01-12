import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myappmoney2/services/shared_preferences_number.dart';

import 'addnumbertochart1.dart';

class Expencesmoney extends StatefulWidget {
  Expencesmoney({super.key});
  static String id = 'Expencesmoney';

  @override
  State<Expencesmoney> createState() => _ExpencesmoneyState();
}

class _ExpencesmoneyState extends State<Expencesmoney> {
  List<SalesData> data = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // تحميل البيانات من SharedPreferences
  loadData() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    SharedPreferencesservice(sharedPreferences).getNumbers().then((numbers) {
      setState(() {
        data = List.generate(numbers.length, (index) {
          return SalesData('Month ${index + 1}', numbers[index]);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Line Chart"),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          title: ChartTitle(text: 'Half Yearly Sales Analysis'),
          legend: Legend(isVisible: true),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries>[
            LineSeries<SalesData, String>(
              dataSource: data,
              xValueMapper: (SalesData sales, _) => sales.month,
              yValueMapper: (SalesData sales, _) => sales.sales,
              name: 'Sales',
              dataLabelSettings: DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // الانتقال إلى صفحة إضافة الأرقام
          bool? dataUpdated = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => addnumbertochart()),
          );
          if (dataUpdated == true) {
            loadData(); // تحميل البيانات بعد إضافة أو تحديث الأرقام
          }
        },
        tooltip: 'Add Number',
        child: Icon(Icons.add),
      ),
    );
  }
}

class SalesData {
  final String month;
  final double sales;

  SalesData(this.month, this.sales);
}
