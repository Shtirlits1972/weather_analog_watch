class City {
  int id = 0;
  String CityName = '';
  String CityNameLocal = '';
  int TimeZone = 0;
  bool IsSelected = false;

  City(this.id, this.CityName, this.CityNameLocal, this.TimeZone,
      this.IsSelected);

  City.empty();

  @override
  String toString() {
    // TODO: implement toString
    return 'id = $id, CityName = $CityName, CityNameLocal = $CityNameLocal, TimeZone = $TimeZone, IsSelected = $IsSelected ';
  }
}
