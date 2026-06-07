import 'dart:developer';
import 'package:path/path.dart';
import 'package:space_anywhere/models/database_models/curiosity_db_model.dart';
import 'package:sqflite/sqflite.dart';

enum DatabaseActions { add, update }

class DatabaseServices {
  Database? _db;

  static final _instance = DatabaseServices._();

  DatabaseServices._();

  factory DatabaseServices.instance() {
    return _instance;
  }

  final String _tableId = "table_id";
  final String _curiosityId = "curiosity_id";
  final String _title = "title";
  final String _shortAnswer = "short_answer";
  final String _longAnswer = "long_answer";
  final String _time = "time";

  final String _fontsId = "font_id";
  final String _font = "font";

  Future<Database> get database async {
    if (_db != null) { return _db!; }
    _db = await createDatabase();
    return _db!;
  }

  Future<Database> createDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "database.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE CURIOSITY (
            $_tableId INTEGER PRIMARY KEY,
            $_curiosityId INTEGER NOT NULL,
            $_title TEXT NOT NULL,
            $_shortAnswer TEXT NOT NULL,
            $_longAnswer TEXT NOT NULL,
            $_time TEXT NOT NULL
          )
          ''');
        db.execute('''
          CREATE TABLE CURIOSITY_FONTS (
            $_fontsId INTEGER PRIMARY KEY AUTOINCREMENT,
            $_font TEXT NOT NULL
          )
          ''');
      },
    );
    return database;
  }

  Future<List<dynamic>> select({required bool getCuriosity}) async {
    final db = await database;
    final List<Map> data;

    data = getCuriosity
        ? await db.query("CURIOSITY")
        : await db.query("CURIOSITY_FONTS");

    final List<dynamic> formatedData = data
        .map(
          (e) => getCuriosity
              ? CuriosityDbModel(
                  id: e["table_id"] as int,
                  curiosityId: e["curiosity_id"] as int,
                  title: e["title"] as String,
                  shortAnswer: e["short_answer"] as String,
                  longAnswer: e["long_answer"] as String,
                  time: e["time"] as String,
                )
              : FontModel(font: e["font"] as String),
        )
        .toList();
    return formatedData;
  }

  Future<void> add({
    CuriosityDbModel? curiosityModel,
    FontModel? fontModel,
    required bool getCuriosity,
  }) async {
    final db = await database;

    try {
      await db.insert(
        getCuriosity ? "CURIOSITY" : "CURIOSITY_FONTS",
        getCuriosity
            ? {
                _curiosityId: curiosityModel!.curiosityId,
                _title: curiosityModel.title,
                _shortAnswer: curiosityModel.shortAnswer,
                _longAnswer: curiosityModel.longAnswer,
                _time: curiosityModel.time,
              }
            : {_font: fontModel!.font},
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> update({required CuriosityDbModel curiosityModel}) async {
    final db = await database;

    try {
      await db.update(
        "CURIOSITY",
        {
          _curiosityId: curiosityModel.curiosityId,
          _title: curiosityModel.title,
          _shortAnswer: curiosityModel.shortAnswer,
          _longAnswer: curiosityModel.longAnswer,
          _time: curiosityModel.time,
        },
        where: "table_id = ?",
        whereArgs: [curiosityModel.id],
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> delete() async {
    final db = await database;

    try {
      await db.delete("CURIOSITY_FONTS");
    } catch (e) {
      log(e.toString());
    }
  }
}
