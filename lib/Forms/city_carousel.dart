import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:w_5/DataF/City.dart';
import 'package:w_5/DataF/CityCrud.dart';
import 'package:w_5/DataF/city_weather.dart';
import 'package:w_5/Repo/RepoCity.dart';
import 'package:w_5/DataF/time_zone_converter.dart';
import 'package:intl/intl.dart';
import 'package:w_5/Repo/weather_repo.dart';

class CityCarousel extends StatefulWidget {
  CityCarousel({Key? key}) : super(key: key);

  @override
  State<CityCarousel> createState() => _CityCarouselState();
}

class _CityCarouselState extends State<CityCarousel> {
  DateTime dt = DateTime.now().toUtc();
  final DateFormat formatter = DateFormat('Hm');

  @override
  Widget build(BuildContext context) {
    return Consumer<RepoCity>(
      builder: (context, repoCity, child) => ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: repoCity.getCityes().length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 10.0,
            color: Colors.lightBlue,
            child: InkWell(
              onTap: () async {
                CityCrud.setNewSelect(repoCity.getCityes()[index].id);
                repoCity.setCurrentCity(repoCity.getCityes()[index]);

                CityWeather cw = await CityCrud.getCityWeather(
                    repoCity.getCityes()[index].CityName);

                Provider.of<RepoWeather>(context, listen: false).setWeather(cw);
              },
              onLongPress: () {
                print('long press for ${repoCity.getCityes()[index].CityName}');

                if (repoCity.getCityes().length > 1) {
                  Future<String?> result = showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Container(
                        decoration:
                            const BoxDecoration(color: Colors.blueAccent),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Внимание!',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      content: Text(
                        'Хотите удалить ${repoCity.getCityes()[index].CityNameLocal} ?',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 25),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            print('Cancel');
                            Navigator.pop(context, 'Cancel');
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            CityCrud.del(repoCity.getCityes()[index].id);
                            repoCity
                                .delCurrCity(repoCity.getCityes()[index].id);

                            print('OK');
                            Navigator.pop(context, 'OK');
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'You can\'t delete last City! ',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      action: SnackBarAction(
                        label: 'OK',
                        onPressed: () {
                          print('OK');
                        },
                      ),
                    ),
                  );

                  print('You can\'t delete last City! ');
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      repoCity.getCityes()[index].CityNameLocal,
                      style: const TextStyle(color: Colors.black, fontSize: 30),
                    ),
                    Text(
                      '${formatter.format(TimeZoneConverter.convert(repoCity.getCityes()[index].TimeZone))} ',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  ListView getCityElem(List<City> lst) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: lst.length,
      itemBuilder: (context, index) {
        return Card(
          child: Text(
            lst[index].CityNameLocal,
            style: const TextStyle(color: Colors.black, fontSize: 30),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // FillCity();
  }
}
