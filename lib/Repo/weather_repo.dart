import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:w_5/DataF/city_weather.dart';

class RepoWeather with ChangeNotifier {
  CityWeather _cityWeather = CityWeather.empty();

  CityWeather get getWeather => _cityWeather;

  setWeather(CityWeather cityWeather) {
    _cityWeather = cityWeather;
    notifyListeners();
  }
}
