import 'dart:async';
import 'package:w_5/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class param2Crud {
  static Future<String> getParam(String NameParam) async {
    String ValueParam = 'Error';

    try {
      String strPath = await getDatabasesPath();
      String path = join(strPath, dbName);

      Database db = await openDatabase(path, version: 1);

      List<Map> list = await db.rawQuery(
          'SELECT ValueParam FROM paramsTab WHERE NameParam = ? ;',
          [NameParam]);

      if (list.isNotEmpty) {
        return list[0]['ValueParam'].toString();
      } else {
        return '';
      }
    } catch (e) {
      print(e);
      return e.toString();
    }
    return ValueParam;
  }

  static Future<void> updParam(String NameParam, String ValueParam) async {
    String command = 'UPDATE paramsTab SET ValueParam = ? WHERE NameParam = ?';

    try {
      String strPath = await getDatabasesPath();
      String path = join(strPath, dbName);
      Database db = await openDatabase(path, version: 1);

      int count = await db.rawUpdate(command, [ValueParam, NameParam]);

      print('row updated = $count ');
    } catch (e) {
      print(e);
    }
  }

  static Future delParam(String NameParam) async {
    String command = 'DELETE FROM paramsTab WHERE NameParam = ?';
    try {
      String strPath = await getDatabasesPath();
      String path = join(strPath, dbName);
      Database db = await openDatabase(path, version: 1);

      int count = await db.rawDelete(command, [NameParam]);

      print('row delete = $count ');
    } catch (e) {
      print(e);
    }
  }

  static Future addParam(String NameParam, String ValueParam) async {
    String command =
        'INSERT INTO paramsTab (NameParam, ValueParam) values(?,?);';
    try {
      String strPath = await getDatabasesPath();
      String path = join(strPath, dbName);
      Database db = await openDatabase(path, version: 1);

      db.transaction((txn) async {
        int id = await txn.rawInsert(command, [NameParam, ValueParam]);
        print(id);
      });
    } catch (e) {
      print(e);
    }
  }
}
