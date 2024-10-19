import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'order.dart';
import 'user.dart'; // Import the User class

class DatabaseHelper {
  // Singleton pattern for the database helper
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();


  static Database? _database;

  // Table names and database name
  final String _dbName = 'app_database.db';
  final String _userTable = 'user';

  // Columns for the user table
  final String _colId = 'id';
  final String _colName = 'name';
  final String _colAge = 'age';
  final String _colEmail = 'email';
  // Order table and columns
  final String _orderTable = 'orderTable';
  final String _colProductName = 'productName';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    print("DatabaseHelper path-> $path");
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Handle the upgrade

    );
  }

  // Create tables
  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_userTable (
        $_colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $_colName TEXT NOT NULL,
        $_colAge INTEGER NOT NULL,
        $_colEmail TEXT 

      )
    ''');


    // Create the Order table
    await db.execute('''
      CREATE TABLE $_orderTable (
        $_colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $_colProductName TEXT NOT NULL
      )
    ''');
  }
  // Handle database upgrade
  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // Add the new email column in version 2
      await db.execute('ALTER TABLE $_userTable ADD COLUMN $_colEmail TEXT');

      // Create the Order table in version 3 becasue in order table launched in version 3 new version should be older version wa 2
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $_orderTable (
          $_colId INTEGER PRIMARY KEY AUTOINCREMENT,
          $_colProductName TEXT NOT NULL
        )
      ''');
    }
  }

  /*
  * if you don't have order table in version 2  and new version need to update to 3 because old version 2 doesn't have
  * order table database
  * onCreate not called if file not exist
  * */

  // FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  //   if (oldVersion < 3) {
  //     // Create the Order table in version 3
  //     await db.execute('''
  //     CREATE TABLE IF NOT EXISTS $_orderTable (
  //       $_colId INTEGER PRIMARY KEY AUTOINCREMENT,
  //       $_colProductName TEXT NOT NULL
  //     )
  //   ''');
  //   }
  //
  //   if (oldVersion < 2) {
  //     // Handle any upgrades from version 1 to version 2 here (if needed)
  //     await db.execute('ALTER TABLE $_userTable ADD COLUMN $_colEmail TEXT');
  //   }
  // }


  // Insert a new user into the database
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert(_userTable, user.toMap());
  }

  // Fetch all users from the database
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query(_userTable);
  }
  // Update user details in the database
  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      _userTable,
      user.toMap(),
      where: '$_colId = ?',
      whereArgs: [user.id],
    );
  }

  // Delete a user by ID
  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      _userTable,
      where: '$_colId = ?',
      whereArgs: [id],
    );
  }



  // Insert a new order into the database
  Future<int> insertOrder(Order order) async {
    final db = await database;
    return await db.insert(_orderTable, order.toMap());
  }
  // Fetch all orders from the database
  Future<List<Map<String, dynamic>>> getOrders() async {
    final db = await database;
    return await db.query(_orderTable);
  }
  // Update order details in the database
  Future<int> updateOrder(Order order) async {
    final db = await database;
    return await db.update(
      _orderTable,
      order.toMap(),
      where: '$_colId = ?',
      whereArgs: [order.id],
    );
  }
  // Delete an order by ID
  Future<int> deleteOrder(int id) async {
    final db = await database;
    return await db.delete(
      _orderTable,
      where: '$_colId = ?',
      whereArgs: [id],
    );
  }


  // Close the database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
