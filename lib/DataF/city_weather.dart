class CityWeather {
  String CityNameLocal = '';
  int TimeZone = 0;
  String weatherDescr = '';
  String iconWeather = '04d';
  double temp = 0.0;

  CityWeather(this.CityNameLocal, this.TimeZone, this.weatherDescr,
      this.iconWeather, this.temp);
  CityWeather.empty() {
    CityNameLocal = '';
    TimeZone = 0;
    weatherDescr = '';
    iconWeather = '04d';
    temp = 0.0;
  }

  @override
  String toString() {
    return 'CityNameLocal = $CityNameLocal, TimeZone = $TimeZone, weatherDescr = $weatherDescr, iconWeather = $iconWeather, temp = $temp   ';
  }
}
