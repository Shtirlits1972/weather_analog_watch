import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:w_5/DataF/City.dart';
import 'package:w_5/DataF/CityCrud.dart';
import 'package:w_5/DataF/city_weather.dart';
import 'package:w_5/Repo/RepoCity.dart';
import 'package:w_5/Repo/weather_repo.dart';

class AddNewCity extends StatefulWidget {
  const AddNewCity({Key? key}) : super(key: key);

  @override
  State<AddNewCity> createState() => _AddNewCityState();
}

class _AddNewCityState extends State<AddNewCity> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Add new City',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          const Text(
            'City Name',
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          const SizedBox(
            width: 40,
          ),
          SizedBox(
            height: 40,
            width: 300,
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Enter name of City',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent, width: 3),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 100,
                color: Colors.blueAccent,
                child: TextButton(
                  onPressed: () async {
                    if (controller.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Incorrect city name',
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
                    } else {
                      City? city =
                          await CityCrud.getCityFromHttp(controller.text);

                      if (city.CityName.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Incorrect city name',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            action: SnackBarAction(
                              label: 'OK',
                              onPressed: () {
                                print('OK');
                              },
                            ),
                          ),
                        );
                      } else {
                        city = await CityCrud.add(city);

                        if (city != null) {
                          city.IsSelected = true;
                          print(city);
                          Provider.of<RepoCity>(context, listen: false)
                              .addNewCity(city);

                          CityWeather cw =
                              await CityCrud.getCityWeather(city.CityName);
                          await Provider.of<RepoWeather>(context, listen: false)
                              .setWeather(cw);
                        }
                      }
                      Navigator.pushNamed(context, '/');
                    }
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ),
              Container(
                width: 100,
                color: Colors.blueAccent,
                child: TextButton(
                  onPressed: () {
                    print('Cancel');
                    Navigator.pushNamed(context, '/');
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
