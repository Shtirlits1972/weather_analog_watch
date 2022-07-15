import 'package:sqflite/sqflite.dart';
import "package:path/path.dart";
import 'package:w_5/constants.dart';

class paramsCrud {
  static deleteDatabase() {
    try {
      getDatabasesPath().then((String strPath) {
        String path = join(strPath, dbName);
        databaseFactory.deleteDatabase(path);
        print('database is deleted!');
      });
    } catch (e) {
      print('dataBase deleting Error = $e');
    }
  }

  static updParam(String NameParameter, String ValueParameter) {
    try {
      getDatabasesPath().then((String strPath) {
        String path = join(strPath, dbName);

        openDatabase(path, version: 1).then((Database db) {
          db.rawUpdate(
              'UPDATE paramsTab SET ValueParam = ? WHERE NameParam = ?',
              [ValueParameter, NameParameter]);
          db.close();
        });
      });
    } catch (e) {
      print(e);
    }
  }

  static delParam(String NameParam) {
    getDatabasesPath().then((String strPath) {
      String path = join(strPath, dbName);

      openDatabase(path, version: 1).then((Database db) {
        db.transaction((txn) async {
          int count = await txn.rawDelete(
              'DELETE FROM paramsTab WHERE NameParam = ?;', [NameParam]);
          print(count);
        });
      });
    });
  }

  static init() {
    String addLang =
        'insert into paramsTab(NameParam, ValueParam) values ("lang", "ru");';
    String addTheme =
        'insert into paramsTab(NameParam, ValueParam) values ("theme", "light");';

    // open the database
    getDatabasesPath().then((String strPath) async {
      try {
        openDatabase(
          join(strPath, dbName),
          version: 1,
          onCreate: (Database db, int version) async {
            await db.execute('CREATE TABLE paramsTab (' +
                'Id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
                'NameParam VARCHAR(250) UNIQUE, ' +
                'ValueParam VARCHAR(250) ); ');

            print('database initialized!');
          },
        ).then((Database db) {});
      } catch (e) {
        print(e.toString());
      }
    });
  }

  static add(String NameParameter, String ValueParameter) {
    getDatabasesPath().then((String strPath) {
      String path = join(strPath, dbName);

      openDatabase(path, version: 1).then((Database db) {
        db.transaction((txn) async {
          txn.rawInsert(
              'INSERT INTO paramsTab (NameParam, ValueParam) values(?,?);',
              [NameParameter, ValueParameter]).then((var res) {
            print(res);
          });
        });
      });
    });
  }

  static String getParam(String NameParameter) {
    String ValueParameter = '';

    try {
      getDatabasesPath().then((String strPath) {
        String path = join(strPath, dbName);

        openDatabase(path, version: 1).then((Database db) {
          db.rawQuery('SELECT ValueParam FROM paramsTab WHERE NameParam = ? ; ',
              [NameParameter]).then((List<Map> result) {
            if (result.isNotEmpty) {
              return result[0]['ValueParam'].toString();
            } else {
              return '';
            }
          });
          db.close();
        });
      });
    } catch (e) {
      print(e);
    }

    return ValueParameter;
  }
}
