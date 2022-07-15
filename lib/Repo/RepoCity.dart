import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:w_5/DataF/City.dart';
// import 'package:w_5/DataF/CityCrud.dart';

class RepoCity with ChangeNotifier {
  List<City> _listCity = [];
  City curCity = City.empty();

  List<City> getCityes() {
    return _listCity;
  }

  delCurrCity(int id) {
    if (_listCity.isNotEmpty) {
      int index = 0;
      bool flag = false;

      for (int i = 0; i < _listCity.length; i++) {
        if (_listCity[i].id == id) {
          flag = true;
          index = i;
        }
      }
      if (flag) {
        _listCity.removeAt(index);
      }
    }

    notifyListeners();
  }

  setCurrentCity(City city) {
    for (int i = 0; i < _listCity.length; i++) {
      if (_listCity.isEmpty) {
        curCity = city;
      } else if (_listCity.length > 0) {
        if (_listCity[i].id == city.id) {
          _listCity[i].IsSelected = true;
          curCity = _listCity[i];
        } else {
          _listCity[i].IsSelected = false;
        }
      }
    }
    notifyListeners();
  }

  City getCurentCity() {
    return curCity;
  }

  addNewCity(City city) {
    if (city.IsSelected) {
      for (int i = 0; i < _listCity.length; i++) {
        _listCity[i].IsSelected = false;
      }
    }

    _listCity.add(city);
    curCity = city;
    notifyListeners();
  }

  void setCityes(List<City> newList) {
    _listCity = newList;
    bool flag = false;

    for (int i = 0; i < _listCity.length; i++) {
      if (_listCity[i].IsSelected == true) {
        curCity = _listCity[i];
        flag = true;
        notifyListeners();
        break;
      }
    }

    if (flag == false) {
      _listCity[0].IsSelected = true;
      curCity = _listCity[0];
      notifyListeners();
    }

    notifyListeners();
  }
}
