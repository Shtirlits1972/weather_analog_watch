import 'dart:async';
import 'package:w_5/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class InitCrud {
  static init() async {
    String createParamTab = 'CREATE TABLE paramsTab (' +
        ' id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
        ' NameParam VARCHAR(250) UNIQUE, ' +
        ' ValueParam VARCHAR(250)  ); ';

    String createCityTab = 'CREATE TABLE [City](  ' +
        '[id] INTEGER PRIMARY KEY AUTOINCREMENT,  ' +
        '[CityName] NVARCHAR, ' +
        '[CityNameLocal] NVARCHAR,' +
        '[TimeZone] INT DEFAULT 0, ' +
        '[IsSelected] BOOL NOT NULL DEFAULT False);  ';

    String themeAdd =
        'INSERT INTO paramsTab (NameParam, ValueParam) values(\'theme\',\'light\');';

    String langAdd =
        'INSERT INTO paramsTab (NameParam, ValueParam) values(\'lang\',\'ru\');';

    getDatabasesPath().then((String strPath) {
      String path = join(strPath, dbName);
      try {
        final database = openDatabase(path, onCreate: (db, version) async {
          db.execute(createCityTab);
          db.execute(createParamTab);
          print('table paramsTab Created');
          await db.execute(themeAdd);
          await db.execute(langAdd);
          print('theme added!');
        }, version: 1);
      } catch (e) {
        print(e);
      }
    });
  }
}
