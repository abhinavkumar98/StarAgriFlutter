import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:staragri/model/expense.dart';

class Chart extends StatefulWidget {
  final List<Expense> _items;

  Chart(this._items);

  @override
  _ChartState createState() => _ChartState(_items);
}

class _ChartState extends State<Chart> {
  List<PieChartSectionData> _sections = List<PieChartSectionData>();
  List<Expense> _itemList = List<Expense>();

  _ChartState(this._itemList);

  @override
  void initState() {
    super.initState();
   
    Map<int, List<Expense>> myMap = groupBy(_itemList);
    for (int i = 0; i < myMap.length; i++) {
      PieChartSectionData _item1 = PieChartSectionData(
        color: getColorsForType(myMap.keys.elementAt(i)),
        value: _calculateTotalAmountForEachExpense(myMap.values.elementAt(i)).toDouble(),
        title: myMap.values.elementAt(i)[0].expenseType,
        radius: 70,
        titleStyle: TextStyle(color: Colors.black, fontSize: 24),
      );
      _sections.add(_item1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
            centerSpaceRadius: 40,
            sectionsSpace: 0,
            borderData: FlBorderData(
              show: false,
            ),
            sections: _sections,
          ),
        ),
      ),
    );
  }

  Map<int, List<Expense>> groupBy(List<Expense> expenseList) {
    var expenseMap = <int, List<Expense>>{};
    for (var element in expenseList) {
      var list = expenseMap.putIfAbsent(element.expenseTypeId, () => []);
      list.add(element);
    }
    return expenseMap;
  }

  int _calculateTotalAmountForEachExpense(List<Expense> expenseList) {
    int total = 0;
    expenseList.forEach((element) => (total += element.amount));
    return total;
  }

  Color getColorsForType(int typeId) {
    Color color = Colors.black;
    switch (typeId) {
      case 1:
        color = Colors.blueAccent;
        break;
      case 2:
        color = Colors.redAccent;
        break;
      case 3:
        color = Colors.orangeAccent;
        break;
      case 4:
        color = Colors.yellowAccent;
        break;
      case 5:
        color = Colors.greenAccent;
        break;
    }
    return color;
  }
}