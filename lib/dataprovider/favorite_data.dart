import 'dart:convert';
import 'dart:io';

import 'package:motivate_linux/model/quotes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteDataProvider {
  static final _dbName = 'MotivationalQuotesAppDB';
  static final _dbVersion = 1;
  static final _tableName = 'favorites';

  static final columnID = 'ID';
  static final columnEngVersion = 'EngVersion';
  static final columnEngPerson = 'EngPerson';
  static final columnAmhVersion = 'AmhVersion';
  static final columnAmhPerson = 'AmhPerson';
  static final columnEngCategory = 'EngCategory';
  static final columnAmhCategory = 'AmhCategory';

  FavoriteDataProvider._privateConstructor();
  static final FavoriteDataProvider dbInstance =
      FavoriteDataProvider._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initiateDatabase();
    return _database;
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    db.execute('''
      CREATE TABLE $_tableName (
      $columnID INTEGER PRMARY KEY,
      $columnEngPerson TEXT NOT NULL,
      $columnAmhPerson TEXT NOT NULL,
      $columnEngVersion TEXT NOT NULL,
      $columnAmhVersion TEXT NOT NULL,
      $columnEngCategory TEXT NOT NULL,
      $columnAmhCategory TEXT NOT NULL
      )
      ''');
  }

  Future<int> inserIntoDatabase(Quote quote) async {
    Database db = await dbInstance.database;
    final row = quote.toMap(
        columnID,
        columnEngPerson,
        columnAmhPerson,
        columnEngVersion,
        columnAmhVersion,
        columnEngCategory,
        columnAmhCategory);
    return await db.insert((_tableName), row);
  }

  Future<List<Quote>> readFromDatabase() async {
    Database db = await dbInstance.database;
    final result = await db.query(_tableName);
    final quotesmapped = result.map((quote) => Quote.fromMap(quote)).toList();
    return quotesmapped;
  }

  Future<int> updateInDatabase(Quote quote) async {
    Database db = await dbInstance.database;
    final row = quote.toMap(
        columnID,
        columnEngPerson,
        columnAmhPerson,
        columnEngVersion,
        columnAmhPerson,
        columnEngCategory,
        columnAmhCategory);
    int id = row[columnID];
    return await db
        .update((_tableName), row, where: '$columnID = ?', whereArgs: [id]);
  }

  Future<int> deleteFromDatabase(Quote quote) async {
    Database db = await dbInstance.database;
    return await db
        .delete(_tableName, where: '$columnID = ?', whereArgs: [quote.id]);
  }
}
