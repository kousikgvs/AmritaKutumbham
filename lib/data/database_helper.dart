import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:seva_map/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:seva_map/globals.dart' as globals;

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database?> get db async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    if(_db != null) {print('First........');
      return _db;
    }print('second........');
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1,onCreate: _onCreate);
    return theDb;
  }


  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE User(id INTEGER PRIMARY KEY,user_id TEXT, username TEXT, password TEXT)");
    print("Created tables");
  }

  Future<int?> saveUser(User user) async {
    var dbClient = await db;
    int? res = await dbClient?.insert("User", user.toMap());
    print('user saved$res');
    var reslt = await dbClient?.query("User");
    print('reslt saved....$reslt');
    return res;
  }

  Future<int?> deleteUsers() async {
    var dbClient = await db;
    int? res = await dbClient?.delete("User");
    return res;
  }

  Future<bool> isLoggedIn() async {
    var dbClient = await db;print('user saved...11');
    var res = await dbClient?.query("User");
    print('user saved....$res');
    if(res != null && res.isNotEmpty){
      globals.isLoggedIn = true;
      globals.userId = res[0]['user_id'] as String;
      return true;
    }
    return false;
  }


}