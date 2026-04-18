import 'dart:developer';
import 'package:path/path.dart';
import 'package:space_anywhere/models/database_models/curiosity_db_model.dart';
import 'package:sqflite/sqflite.dart';

enum DbActions {
  add,
  update
}

class DbServices {
  Database? _db;

  static final _instance = DbServices._();

  factory DbServices.instance() {
    return _instance;
  }

  DbServices._();

  final String _tableId = "table_id"; 
  final String _curiosityId = "curiosity_id";
  final String _title = "title";
  final String _shortAnswer = "short_answer";
  final String _longAnswer = "long_answer";
  final String _time = "time";

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await createDatabase();
    return _db!;
  }

  Future<Database> createDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "local_storage.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          '''
          CREATE TABLE CURIOSITY (
            $_tableId INTEGER PRIMARY KEY,
            $_curiosityId INTEGER NOT NULL,
            $_title TEXT NOT NULL,
            $_shortAnswer TEXT NOT NULL,
            $_longAnswer TEXT NOT NULL,
            $_time TEXT NOT NULL
          )
          '''
        );
      }
    );
    return database;
  }

  Future<List<CuriosityDbModel>> select() async {
    final db = await database;
    final List<Map> data;

    data = await db.query("CURIOSITY");

    final List<CuriosityDbModel> formatedData = data.map(
      (e) => CuriosityDbModel(
        id: e["table_id"] as int,
        curiosityId: e["curiosity_id"] as int, 
        title: e["title"] as String, 
        shortAnswer: e["short_answer"] as String, 
        longAnswer: e["long_answer"] as String, 
        time: e["time"] as String,
      )
    ).toList();

    return formatedData;
  }

  Future<void> add(CuriosityDbModel curiosityModel) async {
    final db = await database;

    try {
      await db.insert(
        "CURIOSITY", 
        {
          _curiosityId : curiosityModel.curiosityId,
          _title : curiosityModel.title,
          _shortAnswer : curiosityModel.shortAnswer,
          _longAnswer : curiosityModel.longAnswer,
          _time : curiosityModel.time,
        }
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> update(CuriosityDbModel curiosityModel) async {
    final db = await database;

    try {
      await db.update(
        "CURIOSITY", 
        {
          _curiosityId : curiosityModel.curiosityId,
          _title : curiosityModel.title,
          _shortAnswer : curiosityModel.shortAnswer,
          _longAnswer : curiosityModel.longAnswer,
          _time : curiosityModel.time,
        },
        where: "table_id = ?",
        whereArgs: [curiosityModel.id],
      );
    } catch (e) {
      log(e.toString());
    }
  }
}