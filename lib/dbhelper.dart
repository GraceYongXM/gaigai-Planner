import 'dart:io' as io;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:gaigai_planner/activity.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

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

    var db = await openDatabase(path, version: 1);
    return db;
  }

  Future<List<Activity>> getActivity() async {
    var dbClient = await database;
    List<Map> list = await dbClient!.rawQuery('SELECT * FROM activities');
    List<Activity> activities = [];
    for (int i = 0; i < list.length; i++) {
      activities.add(Activity(list[i]['id'], list[i]['name'], list[i]['type'],
          list[i]['location'], list[i]['cost'], list[i]['travelTime']));
    }
    return activities;
  }
}
