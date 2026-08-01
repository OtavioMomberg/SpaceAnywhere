import 'dart:developer';
import 'package:path/path.dart';
import 'package:space_anywhere/models/database_models/curiosity_db_model.dart';
import 'package:sqflite/sqflite.dart';

enum DatabaseActions { add, update }

class DatabaseService {
  Database? _db;

  static final _instance = DatabaseService._();

  DatabaseService._();

  factory DatabaseService.instance() {
    return _instance;
  }

  final String _tableNameCuriosity = "CURIOSITY";
  final String _curiosityId = "curiosity_id";
  final String _title = "title";
  final String _shortAnswer = "short_answer";
  final String _longAnswer = "long_answer";
  final String _time = "time";

  final String _tableNameFonts = "CURIOSITY_FONTS";
  final String _fontsId = "font_id";
  final String _font = "font";

  Future<Database> get database async {
    if (_db != null) { return _db!; }
    _db = await createDatabase();
    return _db!;
  }

  Future<Database> createDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "space_anywhere.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE CURIOSITY (
            $_curiosityId INTEGER PRIMARY KEY,
            $_title TEXT NOT NULL,
            $_shortAnswer TEXT NOT NULL,
            $_longAnswer TEXT NOT NULL,
            $_time TEXT NOT NULL
          )
          ''');
        db.execute('''
          CREATE TABLE CURIOSITY_FONTS (
            $_fontsId INTEGER PRIMARY KEY,
            $_font TEXT NOT NULL
          )
          ''');
      }
    );
    return database;
  }

  Future<List<CuriosityDbModel>> selectCuriosity() async {
    final db = await database;
    final List<Map> data;

    data = await db.query(_tableNameCuriosity);

    final List<CuriosityDbModel> formatedData = data.map(
      (item) => CuriosityDbModel(
        curiosityId: item[_curiosityId] as int,
        title: item[_title] as String,
        shortAnswer: item[_shortAnswer] as String,
        longAnswer: item[_longAnswer] as String,
        time: item[_time] as String,
      )
    ).toList();

    return formatedData;
  }

  Future<List<FontModel>> selectFonts() async {
    final db = await database;
    final List<Map> data;

    data = await db.query(_tableNameFonts);

    final List<FontModel> formatedData = data
      .map((item) => FontModel(font: item[_font] as String)).toList();

    return formatedData;
  }

  Future<void> addCuriosity({required CuriosityDbModel curiosityModel}) async {
    final db = await database;

    try {
      await db.insert(_tableNameCuriosity, {
        _curiosityId: curiosityModel.curiosityId,
        _title: curiosityModel.title,
        _shortAnswer: curiosityModel.shortAnswer,
        _longAnswer: curiosityModel.longAnswer,
        _time: curiosityModel.time,
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> addFonts({required FontModel fontModel}) async {
    final db = await database;

    try {
      await db.insert(_tableNameFonts, {_font: fontModel.font});
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateCuriosity({required CuriosityDbModel curiosityModel}) async {
    final db = await database;

    try {
      await db.update(
        _tableNameCuriosity,
        {
          _curiosityId: curiosityModel.curiosityId,
          _title: curiosityModel.title,
          _shortAnswer: curiosityModel.shortAnswer,
          _longAnswer: curiosityModel.longAnswer,
          _time: curiosityModel.time,
        },
        where: "$_curiosityId = ?",
        whereArgs: [curiosityModel.curiosityId],
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deleteFonts() async {
    final db = await database;

    try {
      await db.delete(_tableNameFonts);
    } catch (e) {
      log(e.toString());
    }
  }
}
