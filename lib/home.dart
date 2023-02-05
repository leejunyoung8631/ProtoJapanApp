import "package:flutter/material.dart";

import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart'; // for api key

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState({key: Key});

  final weather_api = dotenv.env['OPENWEATHER'];

  Widget weather() {
    return Expanded(
      child: Column(
        children: [
          // today realtime
          Row(
            children: [],
          ),
          // today timeline
          Row(
            children: [],
          ),
          // future weather
          Column(
            children: [],
          ),
        ],
      ),
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
