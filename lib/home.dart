import "package:flutter/material.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart'; // for api key

import 'weather.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState({key: Key});

  // final weather_api = dotenv.env['OPENWEATHER'];

  /////////// temp//////??//////??//////??//////??//////??
  Future<dynamic> readJson() async {
    final String response =
        await rootBundle.loadString("assets/etc/testcall.json");
    final d = await json.decode(response);
    debugPrint("read jsonfile");

    return WholeWeather(d);
  }

  //////??//////??//////??//////??//////??//////??//////??

  Widget weather() {
    return FutureBuilder(
      future: readJson(),
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return CircularProgressIndicator();
        } else {
          return Expanded(
            child: Column(
              children: [
                // today realtime
                realtime(snapshot.data),
                // today timeline
                timeline(snapshot.data),
                // future weather
                futureweather(snapshot.data),
              ],
            ),
          );
        }
      },
    );
  }

  Widget realtime(var data) {
    var weather_path = data.dailyList[0].weather_path;

    return Container(
      height: 130,
      child: Row(children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(
                image: AssetImage(weather_path),
              ),
              Text(
                data.dailyList[0].weather.toString(),
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                data.dailyList[0].timeZone,
                style: TextStyle(fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    data.dailyList[0].av_temp,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(data.dailyList[0].min_temp),
                  Text("~"),
                  Text(data.dailyList[0].max_temp),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.water_drop_rounded,
                    color: Colors.blue,
                  ),
                  Text(data.dailyList[0].humidity + "%"),
                  Text(data.dailyList[0].riseset),
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }

  Widget timeline(var data) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 100,
        itemBuilder: ((context, index) {
          return Text("$index");
        }),
      ),
    );
  }

  Widget futureweather(var data) {
    return Container();
  }

  Widget restaurantGenerator() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        weather(),
        restaurantGenerator(),
      ],
    );
  }
}
