import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:w_5/DataF/City.dart';
import 'package:w_5/DataF/CityCrud.dart';
import 'package:w_5/DataF/InitCrud.dart';
import 'package:w_5/DataF/city_weather.dart';
import 'package:w_5/Forms/city_carousel.dart';
import 'package:w_5/Repo/RepoCity.dart';
import 'package:w_5/Repo/RepoParam.dart';
import 'package:w_5/Repo/weather_repo.dart';
import 'package:w_5/analog_clock/clock_view.dart';
import 'package:w_5/constants.dart';
import 'package:intl/intl.dart';
import 'package:weather_icons/weather_icons.dart';
import 'dart:async';

class StartPage extends StatefulWidget {
  const StartPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  Color appBack = Colors.blue;
  String currTime = '';
  String currData = '';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RepoParam(),
      child: Consumer<RepoParam>(
        builder: (context, theme2, child) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: theme2.getTheme() ? Colors.blue : Colors.grey,
            title: Text(
              title,
              style: TextStyle(
                color: (theme2.getTheme() ? Colors.white : Colors.black),
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () async {
                  Navigator.pushNamed(context, '/add_new_city_form');
                },
                icon: const Icon(Icons.add_circle_outline),
                tooltip: 'Add new City',
              )
            ],
          ),
          body: Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 20,
              width: MediaQuery.of(context).size.width - 20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                Provider.of<RepoCity>(context)
                                    .getCurentCity()
                                    .CityNameLocal,
                                style: const TextStyle(
                                    fontSize: 40, color: Colors.black),
                              ),
                              Text(
                                currTime,
                                style: const TextStyle(
                                    fontSize: 30, color: Colors.black),
                              ),
                              Text(
                                currData,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        const Expanded(
                          //  plug
                          child: ClockView(),
                          flex: 6,
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(color: Colors.blueGrey),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          width: 1,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              top: 10, right: 5),
                                          child: Image.network(
                                              'http://openweathermap.org/img/w/${Provider.of<RepoWeather>(context, listen: false).getWeather.iconWeather}.png'),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            't=${Provider.of<RepoWeather>(context, listen: false).getWeather.temp}',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 25),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          width: 10,
                                          child: const Icon(
                                            WeatherIcons.celsius,
                                            color: Colors.black,
                                            size: 35.0,
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 2,
                                        child: SizedBox(
                                          width: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  // Weather description
                                  flex: 1,
                                  child: Text(
                                    ' ${Provider.of<RepoWeather>(context, listen: false).getWeather.weatherDescr}',
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 25),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CityCarousel(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  initAnalogClock() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        final DateFormat formatter = DateFormat('Hms');
        final DateFormat formatterDate = DateFormat('EEE dd.MM.yyyy', 'RU');
        Duration dur = Duration(
            seconds: Provider.of<RepoCity>(context, listen: false)
                .getCurentCity()
                .TimeZone); //  TimeZoneConverter.convert();
        DateTime dtL = DateTime.now().toUtc().add(dur);
        currTime = formatter.format(dtL);
        currData = formatterDate.format(dtL);
      });
    });
  }

  FillCity() async {
    List<City> list = await CityCrud.getAllCity();
    print(' FillCity list.length = ${list.length}');
    int y = 0;

    if (list.isEmpty) {
      print('list empty');
      City city = await CityCrud.getCityByCoord();
      city.IsSelected = true;
      print(city);
      list.add(city);
      // Provider.of<RepoCity>(context, listen: false).setCityes(list);
      CityWeather cv = await CityCrud.getCityWeather(city.CityName);
      Provider.of<RepoWeather>(context, listen: false).setWeather(cv);
      //
    }

    bool flag = false;
    for (int i = 0; i < list.length; i++) {
      if (list[i].IsSelected) {
        CityWeather cv = await CityCrud.getCityWeather(list[i].CityName);
        Provider.of<RepoWeather>(context, listen: false).setWeather(cv);
        Provider.of<RepoCity>(context, listen: false).setCityes(list);
        flag = true;
        break;
      }
    }

    if (flag == false) {
      list[0].IsSelected = true;
      CityWeather cv = await CityCrud.getCityWeather(list[0].CityName);
      Provider.of<RepoWeather>(context, listen: false).setWeather(cv);
      Provider.of<RepoCity>(context, listen: false).setCityes(list);
    }
  }

  @override
  void initState() {
    //  FillCity();
    initializeDateFormatting();
    initAnalogClock();

    super.initState();
  }
}
