import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Expenses.dart';

class DatabaseHelper {
  static final _databaseName = "expensedb.db";
  static final _databaseVersion = 1;

  static final table = 'expenses_table';

  static final columnId = 'id';
  static final columnExpenseType = 'expenseType';
  static final columnAmount = 'amount';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnExpenseType TEXT NOT NULL,
            $columnAmount INTEGER NOT NULL
          )
          ''');
  }

  Future<int> insert(Expense expense) async {
    Database db = await instance.database;
    return await db.insert(
        table, {'expenseType': expense.expenseType, 'amount': expense.amount});
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  // Queries rows based on the argument received
  Future<List<Map<String, dynamic>>> queryRows(name) async {
    Database db = await instance.database;
    return await db.query(table, where: "$columnExpenseType LIKE '%$name%'");
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }
}
