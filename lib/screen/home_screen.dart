
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:staragri/model/expense.dart';
import 'package:staragri/screen/google_map.dart';
import 'package:staragri/utils/constants.dart';
import 'package:staragri/utils/database_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class ExpenseListFromDB extends StatefulWidget {
  @override
  _ExpenseListFromDBState createState() => _ExpenseListFromDBState();
}

class _ExpenseListFromDBState extends State<ExpenseListFromDB> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Expense> items;

  @override
  Widget build(BuildContext context) {
    if (items == null) {
      items = List<Expense>();
    }
    return Scaffold(
      body: FutureBuilder<List<Expense>>(
        future: databaseHelper.getExpenseList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          this.items = snapshot.hasData ? snapshot.data : List<Expense>();
          return snapshot.hasData
              ? (snapshot.data.isEmpty
                  ? Center(
                      child: Text('Please Add Expense'),
                    )
                  : Column(
                      children: <Widget>[
                        Expanded(
                          child: PieChart(
                            PieChartData(
                              centerSpaceRadius: 40,
                              sectionsSpace: 0,
                              borderData: FlBorderData(
                                show: false,
                              ),
                              sections:
                                  _prepareSectionsForPieChart(snapshot.data),
                            ),
                          ),
                        ),
                        Container(
                          child: Card(
                            margin: EdgeInsets.all(20.0),
                            color: Colors.cyan,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(15.0),
                                  //child: Text(items[index].date),
                                  child: Text("Date"),
                                  // color: Colors.blue,
                                ),
                                Container(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text("Types"),
                                  // color: Colors.blue,
                                ),
                                Container(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text("Amount"),
                                  // color: Colors.blue,
                                ),
                                Container(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text("Pincode"),
                                  // color: Colors.blue,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, int index) {
                              return Dismissible(
                                key: Key(items[index].expenseId.toString()),
                                onDismissed: (direction) {
                                  items.removeAt(index);
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text("Item dismissed."),
                                  ));
                                },
                                background: Container(
                                  color: Colors.red,
                                ),
                                child: ListTile(
                                  title: Card(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.all(10.0),
                                          //child: Text(items[index].date),
                                          child: Text(items[index].date),
                                          //color: Colors.blue,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(items[index].expenseType),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(
                                              items[index].amount.toString()),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(
                                              items[index].pinCode.toString()),
                                        ),
                                        Container(
                                          // padding: EdgeInsets.all(2.0),
                                          child: IconButton(
                                            icon: Icon(Icons.location_on),
                                            color: Colors.black45,
                                            onPressed: () {
                                              _getData(items[index].pinCode.toString());

//                                              _getData(items[index].pinCode.toString());
//                                             _launchMapsUrl(lat,long);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                        ),
                      ],
                    ))
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  //API Calling
  Future<List<Data>> _getData(String pinCode) async {
    http.Response response = await http.get(
        "https://api.worldpostallocations.com/?postalcode=$pinCode&countrycode=IN");
    if (response.statusCode == 200) {
      String data = response.body;
      //print(data);
      var lat = jsonDecode(data)['result'][0]['latitude'];
      var long = jsonDecode(data)['result'][0]['longitude'];

//      //for google Map calling
//      _launchMapsUrl(lat,long);

      //for custom Map calling
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MyHome(double.parse(lat), double.parse(long));
      }));  


      print(lat);
      print(long);
    } else {
      print(response.statusCode);
    }
    return null;
  }
  
  //Google map calling
  void _launchMapsUrl(String lat, String lon) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  Map<String, List<Expense>> _groupBy(List<Expense> expenseList) {
    var expenseMap = <String, List<Expense>>{};
    for (var element in expenseList) {
      var list = expenseMap.putIfAbsent(element.expenseType, () => []);
      list.add(element);
    }
    return expenseMap;
  }

  int _calculateTotalAmountForEachExpense(List<Expense> expenseList) {
    int total = 0;
    expenseList.forEach((element) => (total += element.amount));
    return total;
  }

  Color _getColorsForType(String type) {
    Color color = Colors.black;
    switch (type) {
      case EXPENSE_TYPE_RENT:
        color = Colors.blueAccent;
        break;
      case EXPENSE_TYPE_TECH:
        color = Colors.redAccent;
        break;
      case EXPENSE_TYPE_TRAVEL:
        color = Colors.orangeAccent;
        break;
      case EXPENSE_TYPE_FOOD:
        color = Colors.yellowAccent;
        break;
      case EXPENSE_TYPE_SAVING:
        color = Colors.greenAccent;
        break;
    }
    return color;
  }

  List<PieChartSectionData> _prepareSectionsForPieChart(
      List<Expense> expenseList) {
    List<PieChartSectionData> sections = List<PieChartSectionData>();

    Map<String, List<Expense>> myMap = _groupBy(expenseList);
    for (int i = 0; i < myMap.length; i++) {
      PieChartSectionData _item1 = PieChartSectionData(
        color: _getColorsForType(myMap.keys.elementAt(i)),
        value: _calculateTotalAmountForEachExpense(myMap.values.elementAt(i))
            .toDouble(),
        title: myMap.values.elementAt(i)[0].expenseType,
        radius: 70,
        titleStyle: TextStyle(color: Colors.black, fontSize: 24),
      );
      sections.add(_item1);
    }
    return sections;
  }
}

// for API model
class Data {
  final int id;
  final String country;
  final int postalCode;
  final String state;
  final String latitude;
  final String longitude;
  final String postalLocation;

  Data(this.id, this.country, this.postalCode, this.state, this.latitude,
      this.longitude, this.postalLocation);
}
