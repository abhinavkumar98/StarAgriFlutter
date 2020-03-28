import 'package:flutter/material.dart';
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

class MyHome extends StatelessWidget {
  final List<Expense> items = List<Expense>.generate(30,
      (i) => Expense(i, "Date ${i + 1}", "Type ${i + 1}", "Amount ${i + 1}"));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My App"),
      ),
      body: ListView.builder(
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
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(25.0),
                      //child: Text(items[index].date),
                      child: Text("Date"),
                      color: Colors.blue,
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
    );
  }
}
