import 'package:flutter/material.dart';
import 'package:staragri/main/pie_chart.dart';
import 'package:staragri/model/expense.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

List<Expense> getDetails() {
  List<Expense> expenseList = List<Expense>();
  expenseList.add(Expense(1, "01/01/2020", "Rent", 1, "4000", 4000));
  expenseList.add(Expense(2, "01/01/2020", "Rent", 1, "5000", 5000));
  expenseList.add(Expense(3, "01/01/2020", "Rent", 1, "6000", 6000));
  expenseList.add(Expense(4, "01/01/2020", "Rent", 1, "8000", 8000));
  expenseList.add(Expense(5, "01/01/2020", "Tech", 2, "8000", 8000));
  expenseList.add(Expense(6, "01/01/2020", "Tech", 2, "8000", 8000));
  expenseList.add(Expense(7, "01/01/2020", "Travel", 3, "4000", 4000));
  expenseList.add(Expense(8, "01/01/2020", "Travel", 3, "5000", 5000));
  expenseList.add(Expense(9, "01/01/2020", "Travel", 3, "6000", 6000));
  expenseList.add(Expense(10, "01/01/2020", "Food", 4, "4000", 4000));
  expenseList.add(Expense(11, "01/01/2020", "Food", 4, "5000", 5000));
  expenseList.add(Expense(12, "01/01/2020", "Food", 4, "6000", 6000));
  expenseList.add(Expense(13, "01/01/2020", "Food", 4, "8000", 8000));
  expenseList.add(Expense(14, "01/01/2020", "Saving", 5, "10000", 10000));
  return expenseList;
}

class MyHome extends StatelessWidget {
  final List<Expense> items = getDetails();

//  List<Expense>.generate(30,
//      (i) => Expense(i, "Date ${i + 1}", "Type ${i + 1}", "Amount ${i + 1}"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My App"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Chart(items),
          ),
          Container(
            child: Card(
              margin: EdgeInsets.all(20.0),
              color: Colors.cyan,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(28.0),
                    //child: Text(items[index].date),
                    child: Text("Date"),
                    // color: Colors.blue,
                  ),
                  Container(
                    padding: EdgeInsets.all(28.0),
                    child: Text("Types"),
                    // color: Colors.blue,
                  ),
                  Container(
                    padding: EdgeInsets.all(28.0),
                    child: Text("Amount"),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(25.0),
                            //child: Text(items[index].date),
                            child: Text(items[index].date),
                            //color: Colors.blue,
                          ),
                          Container(
                            padding: EdgeInsets.all(25.0),
                            child: Text(items[index].expenseType),
                          ),
                          Container(
                            padding: EdgeInsets.all(25.0),
                            child: Text(items[index].expenseAmount),
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
      ),
    );
  }
}
