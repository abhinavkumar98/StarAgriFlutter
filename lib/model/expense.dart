class Expense {
  int id;
  String date;
  String expenseType;
  int amount;
  String expenseAmount;
  int expenseId;
  int pinCode;

  Expense(this.date, this.expenseType,this.expenseAmount,this.amount,this.pinCode);
  Expense.withId(this.id,this.date, this.expenseType,this.amount,this.pinCode);


  // int get id => _id;
  // String get date => _date;
  // String get expenseType => _expenseType;
  // int get expenseTypeId => _expenseTypeId;
  // int get amount => _amount;

  // set date(String newDate){
  //   this._date= newDate;
  // }
  // set expenseType(String newExpenseType){
  //   this._expenseType = newExpenseType;
  // }
  // set expenseTypeId(int newExpenseTypeId){
  //   this._expenseTypeId = newExpenseTypeId;
  // }
  // set amount(int newAmount){
  //   this._amount = newAmount;
  // }
// convert Expense into a map object

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    if (id!= null) {
      map['id'] = id;
    }
    map['date'] = date;
    map['expenseType'] = expenseType;
    map['amount'] = amount;
    map['pinCode'] = pinCode;

    return map;
  }

  // Extract a Expense object from a map object
Expense.fromMapObject(Map<String, dynamic> map){
  this.id = map['id'];
  this.date = map['date'];
  this.expenseType = map['expenseType'];
  this.amount = map['amount'];
  this.pinCode = map['pinCode'];
}
}
