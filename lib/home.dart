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
        await rootBundle.loadString("assets/etc/testcall2.json");
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
      decoration: BoxDecoration(
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(5),
      height: 170,
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
                    data.dailyList[0].av_temp + "°C",
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Text(data.dailyList[0].min_temp),
                  Text("~"),
                  Text(data.dailyList[0].max_temp),
                  Text("(°C)")
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.hourlyList.length,
        itemBuilder: ((context, index) {
          return Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            width: 110,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image(
                image: AssetImage(data.hourlyList[index].weather_path),
                width: 50,
                height: 50,
              ),
              Text(data.hourlyList[index].hour),
              Text(data.hourlyList[index].av_temp +
                  "°C"
                      " / " +
                  data.hourlyList[index].humidity +
                  "%")
            ]),
          );
        }),
      ),
    );
  }

  Widget futureweather(var data) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(data.dailyList[1].day),
            Image(
              image: AssetImage(data.dailyList[1].weather_path),
              width: 80,
              height: 80,
            ),
            Text(
              data.dailyList[1].av_temp,
              style: TextStyle(fontSize: 20),
            ),
            Text(data.dailyList[1].min_temp),
            Text("~"),
            Text(data.dailyList[1].max_temp),
            Text("(°C)"),
            Text(data.dailyList[1].humidity + "%"),
          ],
        ),
        Divider(
          thickness: 1,
          color: Colors.grey,
          indent: 10,
          endIndent: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(data.dailyList[2].day),
            Image(
              image: AssetImage(data.dailyList[2].weather_path),
              width: 80,
              height: 80,
            ),
            Text(
              data.dailyList[2].av_temp,
              style: TextStyle(fontSize: 20),
            ),
            Text(data.dailyList[2].min_temp),
            Text("~"),
            Text(data.dailyList[2].max_temp),
            Text("(°C)"),
            Text(data.dailyList[2].humidity + "%"),
          ],
        )
      ]),
    );
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
