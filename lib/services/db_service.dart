import 'dart:developer';
import 'package:path/path.dart';
import 'package:space_anywhere/core/constants/sqlite_constants.dart';
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
            ${SqliteConstants.curiosityId} INTEGER PRIMARY KEY,
            ${SqliteConstants.title} TEXT NOT NULL,
            ${SqliteConstants.shortAnswer} TEXT NOT NULL,
            ${SqliteConstants.longAnswer} TEXT NOT NULL,
            ${SqliteConstants.time} TEXT NOT NULL
          )
          ''');
        db.execute('''
          CREATE TABLE CURIOSITY_FONTS (
            ${SqliteConstants.fontsId} INTEGER PRIMARY KEY,
            ${SqliteConstants.font} TEXT NOT NULL
          )
          ''');
      }
    );
    return database;
  }

  Future<List<CuriosityDbModel>> selectCuriosity() async {
    final db = await database;
    final List<Map> data;

    data = await db.query(SqliteConstants.tableNameCuriosity);

    final List<CuriosityDbModel> formatedData = data.map(
      (item) => CuriosityDbModel(
        curiosityId: item[SqliteConstants.curiosityId] as int,
        title: item[SqliteConstants.title] as String,
        shortAnswer: item[SqliteConstants.shortAnswer] as String,
        longAnswer: item[SqliteConstants.longAnswer] as String,
        time: item[SqliteConstants.time] as String,
      )
    ).toList();

    return formatedData;
  }

  Future<List<FontModel>> selectFonts() async {
    final db = await database;
    final List<Map> data;

    data = await db.query(SqliteConstants.tableNameFonts);

    final List<FontModel> formatedData = data
      .map((item) => FontModel(font: item[SqliteConstants.font] as String)).toList();

    return formatedData;
  }

  Future<void> addCuriosity({required CuriosityDbModel curiosityModel}) async {
    final db = await database;

    try {
      await db.insert(SqliteConstants.tableNameCuriosity, {
        SqliteConstants.curiosityId: curiosityModel.curiosityId,
        SqliteConstants.title: curiosityModel.title,
        SqliteConstants.shortAnswer: curiosityModel.shortAnswer,
        SqliteConstants.longAnswer: curiosityModel.longAnswer,
        SqliteConstants.time: curiosityModel.time,
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> addFonts({required FontModel fontModel}) async {
    final db = await database;

    try {
      await db.insert(SqliteConstants.tableNameFonts, {SqliteConstants.font: fontModel.font});
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateCuriosity({required CuriosityDbModel curiosityModel}) async {
    final db = await database;

    try {
      await db.update(
        SqliteConstants.tableNameCuriosity,
        {
          SqliteConstants.curiosityId: curiosityModel.curiosityId,
          SqliteConstants.title: curiosityModel.title,
          SqliteConstants.shortAnswer: curiosityModel.shortAnswer,
          SqliteConstants.longAnswer: curiosityModel.longAnswer,
          SqliteConstants.time: curiosityModel.time,
        },
        where: "$SqliteConstants.curiosityId = ?",
        whereArgs: [curiosityModel.curiosityId],
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deleteFonts() async {
    final db = await database;

    try {
      await db.delete(SqliteConstants.tableNameFonts);
    } catch (e) {
      log(e.toString());
    }
  }
}