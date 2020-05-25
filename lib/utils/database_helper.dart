import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:staragri/model/expense.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // singleton  DatabaseHelper
  static Database _database;
  String expenseTableName = 'Expense';
  String colId = 'id';
  String colDate = 'date';
  String colExpenseType = 'expenseType';
  String colExpenseTypeId = 'expenseTypeId';
  String colAmount = 'amount';
  String colPinCode = 'pinCode';

  DatabaseHelper._createInstance(); // Named constructor to craate instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Anroid and IOS to store database.
    Directory directory = await getExternalStorageDirectory();
    String path = directory.path + 'expense.db';

    // Open/Create the database at a givem path.

    var expenseDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return expenseDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $expenseTableName($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colDate TEXT,'
        '$colExpenseType TEXT,$colExpenseTypeId INTEGER, $colAmount INTEGER, $colPinCode INTEGER )');
  }

// Fetch operation: Get all Expense objects from database
  Future<List<Map<String, dynamic>>> getAllExpense() async {
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $expenseTableName');
    return result;
  }

  // Fetch operation: Get all Expense objects from database
  Future<List<Map<String, dynamic>>> getAllExpenseType() async {
    Database db = await this.database;
    var result = await db.rawQuery('SELECT $colExpenseType from '
        '$expenseTableName GROUP BY $colExpenseType');
    return result;
  }

// Insert Opertaion: Insert a Expense object  to database
  Future<int> insertExpense(Expense expense) async {
    Database db = await this.database;
    var result = await db.insert(expenseTableName, expense.toMap());
    return result;
  }

// Update operation: Insert a Expense object and save it to database

  Future<int> updateExpense(Expense expense) async {
    var db = await this.database;
    var result = await db.update(expenseTableName, expense.toMap(),
        where: '$colId = ?', whereArgs: [expense.id]);
    return result;
  }

// Delete Operation: Delete a Expense object from database
//(this operation is similar to fetch operation )
// Get number of Expense object in database

// Get the 'map List' [List<Map>] and convert it to 'Expense List' [List<Expense>]
  Future<List<Expense>> getExpenseList() async {
    var mapList = await getAllExpense(); // Get 'Map List' from database
    List<Expense> expenseList = List<Expense>();
    for (Map<String, dynamic> map in mapList) {
      expenseList.add(Expense.fromMapObject(map));
    }
    return expenseList;
  }

// Get the 'map List' [List<Map>] and convert it to 'ExpenseType List [List<String>]
  Future<List<String>> getExpenseTypeList() async {
    var mapList = await getAllExpenseType(); // Get 'Map List' from database
    List<String> expenseTypeList = List<String>();
    for (Map<String, dynamic> map in mapList) {
      expenseTypeList.add(map['$colExpenseType']);
    }
    return expenseTypeList;
  }
}
