import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:w_5/DataF/City.dart';
import 'package:w_5/DataF/CityCrud.dart';
import 'package:w_5/DataF/InitCrud.dart';
import 'package:w_5/DataF/city_weather.dart';
import 'package:w_5/DataF/paramsCrud.dart';
import 'package:w_5/Forms/add_new_city.dart';
import 'package:w_5/Forms/start_page.dart';
import 'package:w_5/Repo/RepoCity.dart';
import 'package:w_5/Repo/weather_repo.dart';
import 'package:w_5/constants.dart';
import 'package:w_5/theme.dart';

import 'Repo/RepoParam.dart';
// import 'package:w_5/DataF/param2Crud.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RepoParam(),
        ),
        ChangeNotifierProvider(
          create: (_) => RepoCity(),
        ),
        ChangeNotifierProvider(
          create: (_) => RepoWeather(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RepoParam(),
      child: Consumer<RepoParam>(builder: (context, theme3, child) {
        return MaterialApp(
          title: title,
          debugShowCheckedModeBanner: false,
          theme: themeData(context),
          darkTheme: darkThemeData(context),
          themeMode: theme3.getTheme() ? ThemeMode.light : ThemeMode.dark,
          initialRoute: '/',
          routes: {
            '/': (context) => StartPage(),
            '/add_new_city_form': (context) => AddNewCity(),
          },
        );
      }),
    );
  }

  FillCity() async {
    List<City> list = await CityCrud.getAllCity();
    print(' FillCity list.length = ${list.length}');
    int y = 0;

    if (list.isEmpty) {
      print('list empty');
      City? city = await CityCrud.getCityByCoord();
      city.IsSelected = true;
      print(city);
      city = await CityCrud.add(city);
      if (city != null) {
        list.add(city);
        // Provider.of<RepoCity>(context, listen: false).setCityes(list);
        CityWeather cv = await CityCrud.getCityWeather(city.CityName);
        Provider.of<RepoWeather>(context, listen: false).setWeather(cv);
      }
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
    InitCrud.init();
    FillCity();
    super.initState();
  }
}
