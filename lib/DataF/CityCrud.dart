import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:w_5/DataF/City.dart';
import 'package:w_5/DataF/city_weather.dart';
import 'package:w_5/DataF/time_zone_converter.dart';
import 'package:w_5/Repo/RepoCity.dart';
import 'package:w_5/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class CityCrud {
  static Future<City?> add(City city) async {
    String command =
        'INSERT INTO City (CityName, CityNameLocal, TimeZone, IsSelected) VALUES (?, ?, ?, ?);';
    try {
      String strPath = await getDatabasesPath();
      String path = join(strPath, dbName);
      Database db = await openDatabase(path, version: 1);

      await clearSelected();

      await db.transaction((txn) async {
        int id = await txn.rawInsert(command, [
          city.CityName,
          city.CityNameLocal,
          city.TimeZone,
          city.IsSelected
        ]);
        city.id = id;
        print(city);
        return city;
      });
    } catch (e) {
      print(e);
    }
    return city;
  }

  static Future del(int id) async {
    String command = 'DELETE FROM City WHERE id = ?';
    try {
      String strPath = await getDatabasesPath();
      String path = join(strPath, dbName);
      Database db = await openDatabase(path, version: 1);

      int count = await db.rawDelete(command, [id]);

      print('row delete = $count ');
    } catch (e) {
      print(e);
    }
  }

  static Future<void> upd(City city) async {
    String command =
        'UPDATE City SET CityName = ? , CityNameLocal = ?,  TimeZone = ?, IsSelected = ? WHERE id = ?';

    try {
      String strPath = await getDatabasesPath();
      String path = join(strPath, dbName);
      Database db = await openDatabase(path, version: 1);

      int count = await db.rawUpdate(command, [
        city.CityName,
        city.CityNameLocal,
        city.TimeZone,
        city.IsSelected,
        city.id
      ]);
      print('City row updated = $count ');
    } catch (e) {
      print(e);
    }
  }

  static Future<List<City>> getAllCity() async {
    List<City> listCity = [];

    try {
      String strPath = await getDatabasesPath();
      String path = join(strPath, dbName);

      Database db = await openDatabase(path, version: 1);

      List<Map> list = await db.rawQuery(
          'SELECT id, CityName, CityNameLocal, TimeZone, IsSelected FROM City ORDER BY IsSelected DESC, TimeZone ASC ; ');

      if (list.isNotEmpty) {
        bool flag = false;
        for (int i = 0; i < list.length; i++) {
          bool IsSell = false;

          if (list[i]['IsSelected'] == 1 || list[i]['IsSelected'] == true) {
            IsSell = true;
            flag = true;
          }

          int a = 0;
          print('IsSell = $IsSell ');

          City city = City(list[i]['id'], list[i]['CityName'],
              list[i]['CityNameLocal'], list[i]['TimeZone'], IsSell);
          listCity.add(city);
        }

        if (flag == false) {
          listCity[0].IsSelected = true;
          upd(listCity[0]);
        }

        return listCity;
      }
    } catch (e) {
      print(e);
    }
    return listCity;
  }

  static clearSelected() async {
    String command = ' UPDATE City SET IsSelected = false; ';
    try {
      String strPath = await getDatabasesPath();
      String path = join(strPath, dbName);
      Database db = await openDatabase(path, version: 1);
      int count = await db.rawUpdate(command);
      print('City row updated = $count ');
    } catch (e) {
      print('Error clearSelected $e ');
    }
  }

  static setNewSelect(int id) async {
    await clearSelected();
    String command = ' UPDATE City SET IsSelected = false  WHERE id = ? ; ';
    try {
      String strPath = await getDatabasesPath();
      String path = join(strPath, dbName);
      Database db = await openDatabase(path, version: 1);

      int count = await db.rawUpdate(command, [id]);
      print('City row updated = $count ');
    } catch (e) {
      print(e);
    }
  }

  static Future<String> checkCityName(String CityName) async {
    String CityNameEN = '';

    Request request = http.Request(
        'GET',
        Uri.parse(
            'http://api.openweathermap.org/geo/1.0/direct?appid=$appid&q=$CityName'));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      print(result);
      List<dynamic> listDynam1 = (json.decode(result) as List<dynamic>);

      if (listDynam1 != null && listDynam1.length > 0) {
        CityNameEN = listDynam1[0]['name'] + ',' + listDynam1[0]['country'];
      } else {
        print('Array is empty!');
      }
    } else {
      print(response.reasonPhrase);
    }

    return CityNameEN;
  }

  static Future<CityWeather> getCityWeather(String CityName) async {
    CityWeather cv = CityWeather.empty();
    Request request = http.Request(
        'GET',
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?q=$CityName&appid=$appid&mode=json&units=metric&lang=ru'));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      print(result);
      dynamic cityWeatherDyn = (json.decode(result) as dynamic);

      if (cityWeatherDyn != null) {
        cv = CityWeather(
            cityWeatherDyn['name'],
            cityWeatherDyn['timezone'],
            cityWeatherDyn['weather'][0]['description'],
            cityWeatherDyn['weather'][0]['icon'],
            double.tryParse(cityWeatherDyn['main']['temp'].toString())!);
      } else {
        print('Array is empty!');
      }
    } else {
      print(response.reasonPhrase);
    }
    return cv;
  }

  static Future<City> getCityFromHttp(String CityName) async {
    City city = City.empty();
    String NameCityWithCountry = await checkCityName(CityName);

    if (!NameCityWithCountry.isEmpty) {
      CityWeather cv = await getCityWeather(NameCityWithCountry);
      city = City(0, NameCityWithCountry, cv.CityNameLocal, cv.TimeZone, false);
    }

    return city;
  }

  static Future<bool> _checkCoordPermiss() async {
    bool flag = false;

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        flag = false;
      } else if (permission == LocationPermission.deniedForever) {
        print("Location permissions are permanently denied");
        flag = false;
      } else {
        print("GPS Location service is granted");
        flag = true;
      }
    } else {
      print("GPS Location permission granted.");
      flag = true;
    }

    return flag;
  }

  static Future<City> getCityByCoord() async {
    City city = City.empty();

    if (await _checkCoordPermiss()) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      double lon = position.longitude;
      double lat = position.latitude;

      print(lon); //Output: 80.24599079
      print(lat); //Output: 29.6593457

      try {
        Request request = http.Request(
            'GET',
            Uri.parse(
                'http://api.openweathermap.org/geo/1.0/reverse?lat=$lat&lon=$lon&limit=1&appid=$appid'));

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          String result = await response.stream.bytesToString();
          print(result);
          List<dynamic> listDynam1 = (json.decode(result) as List<dynamic>);

          if (listDynam1.isNotEmpty) {
            String CityNameEN =
                listDynam1[0]['name'] + ',' + listDynam1[0]['country'];

            city = await getCityFromHttp(CityNameEN);
          } else {
            print('Array is empty!');
          }
        } else {
          print(response.reasonPhrase);
        }
      } catch (e) {
        print(e);
      }
    }

    return city;
  }
}
