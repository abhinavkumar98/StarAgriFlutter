import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:staragri/model/expense.dart';
import 'package:staragri/utils/database_helper.dart';

class AddExpense extends StatefulWidget {
  @override
  AddExpenseState createState() {
    return AddExpenseState();
  }
}

class AddExpenseState extends State<AddExpense> {

  List<String> _expenseType = ['Food','Rent','Saving','Tech','Travel',];
  String _selectedExpenseType;

  TextEditingController dateController = TextEditingController();
//  TextEditingController typeController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();


  var dateValidate = false;
  var typeValidate = false;
  var amountValidate = false;
  var pinCodeValidate = false;

  DatabaseHelper databaseHelper = DatabaseHelper();

  DateTime _currentDate = DateTime.now();
  final dateFormat = new DateFormat('dd/MM/yyyy');
  final errorBorderSide = BorderSide(color: Colors.red, width: 0.0);


  Future<Null> selectDate(BuildContext context) async {
    final DateTime setDate = await showDatePicker(
        context: context,
        initialDate: _currentDate,
        firstDate: DateTime(1990),
        lastDate: DateTime(2025),
        builder: (context, child) {
          return SingleChildScrollView(
            child: child,
          );
        });
    if (setDate != null) {
      setState(() {
        _currentDate = setDate;
        dateController.value =
            TextEditingValue(text: dateFormat.format(setDate));
        print(_currentDate.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Expense"),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10, right: 10.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: GestureDetector(
                onTap: () => selectDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: dateController,
                    style: textStyle,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      errorText: dateValidate ? "Please Enter Date" : null,
                      errorBorder: OutlineInputBorder(
                        borderSide: errorBorderSide,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      labelStyle: textStyle,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'ExpenseType',
                      labelStyle: textStyle,
                      errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                      errorText: typeValidate ? "Please Choose Expense Type!" : null,
                      errorBorder: OutlineInputBorder(
                        borderSide: errorBorderSide,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    isEmpty: _selectedExpenseType == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedExpenseType,
                        isDense: true,
                        onChanged: (String newValue) {
                          setState(() {
                            _selectedExpenseType = newValue;
                            state.didChange(newValue);
                          });
                        },
                        items: _expenseType.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              )
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                controller: amountController,
                style: textStyle,
                keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  labelStyle: textStyle,
                  errorText: amountValidate ? "Please Enter Amount" : null,
                  errorBorder: OutlineInputBorder(
                    borderSide: errorBorderSide,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: TextField(
                maxLength: 6,
                controller: pinCodeController,
                style: textStyle,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Pincode',
                  labelStyle: textStyle,
                  errorText: pinCodeValidate ? "Please Enter PinCode" : null,
                  errorBorder: OutlineInputBorder(
                    borderSide: errorBorderSide,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Save',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        String date = dateController.text.trim();
                        String type = _selectedExpenseType;
                        String amount = amountController.text.trim();
                        String pinCode = pinCodeController.text.trim();
                        if (date.isEmpty) {
                          setState(() {
                            dateValidate = true;
                          });
                        } else if (type == null || type.isEmpty) {
                          setState(() {
                            typeValidate = true;
                          });
                        } else if (amount.isEmpty) {
                          setState(() {
                            amountValidate = true;
                          });
                        }else if (pinCode.length < 6 || pinCode.length > 6
                            || pinCode.isEmpty){
                          setState(() {
                            pinCodeValidate = true;
                          });
                        } else {
                          Expense expense =
                              Expense(date, type, amount,int.parse(amount),int.parse(pinCode));
                          _save(expense);
                        }
                      },
                    ),
                  ),
                  Container(
                    width: 5.0,
                  ),
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Cancel',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        _cancel();
                        setState(() {
                          debugPrint("Cancel button clicked");
                        });
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _save(Expense expense) async {
    moveToLastScreen();
    DatabaseHelper databaseHelper = DatabaseHelper();
    int id = await databaseHelper.insertExpense(expense);
    if (id != null && id > 0) {
      Fluttertoast.showToast(msg: 'Save successfully');
    }
    print('inserted row: $id');
  }

  void _cancel() {
    moveToLastScreen();
  }

  void moveToLastScreen() {
    Navigator.pop(context);
  }
}

//DropdownButton<String>(
//items: _expenses.map((String dropDownStringItem){
//return DropdownMenuItem<String>(
//value: dropDownStringItem,
//child: Text(dropDownStringItem),
//);
//
//}).toList(),
//onChanged: (String valueSelected) {
//setState(() {
//this._currentItemSelected = valueSelected;
//});
//},
//),
