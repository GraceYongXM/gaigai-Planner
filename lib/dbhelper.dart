import 'dart:io' as io;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:gaigai_planner/models/activity.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import './models/user.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper.internal();

  factory DBHelper() => _instance;
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database as Database;
    }
    _database = await initDB();
    return _database as Database;
  }

  DBHelper.internal();

  initDB() async {
    // get database directory's path
    io.Directory docDir = await getApplicationDocumentsDirectory();
    String path = join(docDir.path, 'activities.db');

    bool dbExist = await io.File(path).exists();
    if (!dbExist) {
      // copy database from asset folder
      ByteData data = await rootBundle.load(join('assets', 'activities.db'));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await io.File(path).writeAsBytes(bytes, flush: true);
    }

    var db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    return db;
  }

  Future _onCreate(Database database, int version) async {
    var createUserTable = """CREATE TABLE users(
          id INTEGER PRIMARY KEY,
          username TEXT UNIQUE,
          email TEXT,
          mobileNo TEXT,
          password TEXT
        )""";
    await database.execute(createUserTable);
  }

  Future<List<Activity>> getActivity() async {
    var dbClient = await database;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM activities');
    List<Activity> activities = [];
    for (int i = 0; i < list.length; i++) {
      activities.add(Activity(list[i]['id'], list[i]['name'], list[i]['type'],
          list[i]['location'], list[i]['cost'], list[i]['travelTime']));
    }
    return activities;
  }

  Future<List<User>> getUsers() async {
    var dbClient = await database;
    List<Map> list = await dbClient.query('users', columns: null);
    List<User> users = [];
    for (int i = 0; i < list.length; i++) {
      users.add(User.fromMap(list[i]));
    }
    return users;
  }

  Future<int> createUser(User user) async {
    var dbClient = await database;
    int res = await dbClient.insert("users", user.toMap());
    return res;
  }

  Future<int> deleteUser(User user) async {
    var dbClient = await database;
    int res = await dbClient.delete(
      "users",
      where: 'id = ?',
      whereArgs: [user.id],
    );
    return res;
  }

  Future<int> updateUser(User user) async {
    var dbClient = await database;
    int res = await dbClient.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
    return res;
  }

  Future<User?> userExists(String username) async {
    var dbClient = await database;
    //var res = await dbClient.rawQuery("Select * FROM users");
    var res = await dbClient.query(
      "users",
      where: 'username = ?',
      whereArgs: [username],
    );
    if (res.isNotEmpty) {
      return User.fromMap(res.first);
    }
    return null;
  }

  Future<User?> canLogin(String username, String password) async {
    var dbClient = await database;
    var res = await dbClient.rawQuery(
        "SELECT * FROM users WHERE username = '$username' and password = '$password'");
    if (res.isNotEmpty) {
      return User.fromMap(res.first);
    }
    return null;
  }
}
