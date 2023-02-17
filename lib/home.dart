import 'dart:math';

import "package:flutter/material.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart'; // for api key

import 'weather.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart'; // for restaturant generator

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState({key: Key});

  // final weather_api = dotenv.env['OPENWEATHER'];

  // whole page
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Weather(),
          RestaurantGenerator(),
        ],
      ),
    );
  }
}

// Showing Weather
class Weather extends StatefulWidget {
  Weather({key: Key});

  @override
  State<Weather> createState() => _StateWeather();
}

class _StateWeather extends State<Weather> {
  // bring data
  Future<dynamic> readJson() async {
    final String response =
        await rootBundle.loadString("assets/etc/testcall2.json");
    final d = await json.decode(response);
    debugPrint("read jsonfile");

    return WholeWeather(d);
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: readJson(),
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return CircularProgressIndicator();
        } else {
          return Column(
            children: [
              // today realtime
              realtime(snapshot.data),
              // today timeline
              timeline(snapshot.data),
              // future weather
              futureweather(snapshot.data),
            ],
          );
        }
      },
    );
  }
}

// Random generator of restaurant
class RestaurantGenerator extends StatefulWidget {
  RestaurantGenerator({key: Key});

  @override
  State<RestaurantGenerator> createState() => _RestaurantGeneratorState();
}

class _RestaurantGeneratorState extends State<RestaurantGenerator> {
  final _area = ["Osaka", "Tokyo", "Fukuoka", "Kobe", "Nagoya"];
  String _selectArea = "Osaka";
  String component = "not-decided";

  // For generated info
  final firestore = FirebaseFirestore.instance;
  var name = "",
      recommend = "",
      image_path = "",
      category = "",
      menu = "",
      location = "",
      price = "";

  // then을 써야 불러 온 다음 행동을 할 수 있는 듯 싶다.
  Future<void> resGenerate(String loac) async {
    int len, randomIndex;
    await firestore.collection(loac).get().then((QuerySnapshot querySnapshot) {
      len = querySnapshot.docs.length;
      randomIndex = Random().nextInt(len);
      var temp = querySnapshot.docs.elementAt(randomIndex);
      image_path = temp["picture"];
      category = temp["category"];
      menu = temp["menu"];
      location = temp["address"] ?? "null"; // null exception
      price = "*" * int.parse(temp["price"]);
      recommend = "*" * int.parse(temp["recommend"]);
      name = temp["name"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      height: 220,
      child: Column(
        children: [
          Flexible(
              flex: 1,
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Today, What to eat",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )),
          Flexible(
            flex: 4,
            child: (component == "not-decided")
                ? Container(
                    child: Text("Select loaction & click the button"),
                    alignment: Alignment.center,
                  ) // before clicking random
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // image of restaurant
                      Flexible(
                        flex: 2,
                        child: Text(image_path), // image of menu
                      ),
                      // spec of restaurant
                      Flexible(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Text("Category : $category "),
                                  Text("Menu : $menu"), // put menu name
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Location : $location"),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("Price : $price "),
                                  Text(
                                      "Recommend : $recommend"), // number of stars
                                ],
                              ),
                            ],
                          )),
                    ],
                  ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Text("   Selected Area : "),
                DropdownButton(
                  value: _selectArea,
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  items: _area.map<DropdownMenuItem<String>>((e) {
                    return DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    );
                  }).toList(),
                  onChanged: (String? e) {
                    setState(() {
                      _selectArea = e!;
                    });
                  },
                ),
                Expanded(child: Text("")),
                ElevatedButton(
                    onPressed: () async {
                      await resGenerate(_selectArea);
                      setState(() {
                        component = _selectArea;
                      });
                    },
                    child: Text("Random")),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
