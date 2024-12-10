import 'dart:async';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "leituracocho.db";
  static const _databaseVersion = 1;

  static late Database _lazyInstance;

  static Future<Database> get instance async =>
      _lazyInstance = await _initDatabase();

  static Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // SQL code to create the database table
  static Future _onCreate(Database db, int version) async {
    final String scriptCreate =
        await rootBundle.loadString("assets/sql/create.sql");
    final sqlCreate = scriptCreate.split(";");

    for (final sql in sqlCreate) {
      if (sql.trim().isNotEmpty) {
        await db.execute(sql);
      }
    }
  }

  static Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Example
    //if (oldVersion < 2) {
    //  await upgraderInteractor(db, Migration01To02.queries);
    //}
  }

  Future close() {
    final dbClient = _lazyInstance;
    return dbClient.close();
  }

  static Future<void> upgraderInteractor(db, List<String> queriesList) async {
    for (final sql in queriesList) {
      if (sql.trim().isNotEmpty) {
        await db.execute(sql);
      }
    }
  }
}
