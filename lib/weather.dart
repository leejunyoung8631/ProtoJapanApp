import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import 'package:intl/intl.dart';

class WholeWeather {
  // weahterList = [ today, oneDay, twoDay, threeDay]
  late List<Weather> hourlyList;
  late List<Weather> dailyList;

  WholeWeather(var whole) {
    getDailyList(whole);
    getHourlyList(whole);
  }

  void getDailyList(var whole) {
    dailyList = List<Weather>.generate(3, (int index) {
      return Weather(whole, id: index, isDaily: true);
    });
  }

  void getHourlyList(var whole) {
    hourlyList = List<Weather>.generate(16, (index) {
      return Weather(whole, id: index, isDaily: false);
    });
  }
}

// weahter
// Clear, Clouds, Snow, Rain, Thunderstorm, Drizzle
// Mist, Smoke, Haze, Dust, Fog, Sand, Dust, Ash, Squall, Tornado

// I use api one call of OpenWeather (1000 calls free)

class Weather {
  // unique
  var av_temp, min_temp, max_temp;
  var weather, cloud, humidity;
  var weather_path;
  var rise_t, set_t, riseset;
  var day, hour;
  // common
  var timeZone, timeOffset;

  // Time time = Time();
  late DateTime currentTime;
  late DateTime sunrise;
  late DateTime sunset;

  // isToday : setting for today or 3 days
  // whole : jsonfile
  Weather(var whole, {int id = 0, isDaily = true}) {
    timeZone = whole["timezone"].toString();
    timeOffset = whole["timezone_offset"];

    if (isDaily == true) {
      av_temp = whole["daily"][id]["temp"]["day"].round().toString();
      min_temp = whole["daily"][id]["temp"]["min"].round().toString();
      max_temp = whole["daily"][id]["temp"]["max"].round().toString();

      weather = whole["daily"][id]["weather"][0]["main"].toString();
      weather_path = "assets/images/$weather.png";
      cloud = whole["daily"][id]["clouds"].toString();
      humidity = whole["daily"][id]["humidity"].toString();

      var t = whole["daily"][id]["dt"];
      currentTime =
          DateTime(1970, 01, 01).add(Duration(seconds: t + timeOffset));
      day = DateFormat.Md().format(currentTime);

      rise_t = whole["daily"][id]["sunrise"];
      sunrise =
          DateTime(1970, 01, 01).add(Duration(seconds: rise_t + timeOffset));
      rise_t = DateFormat.Hm().format(sunrise).toString();

      set_t = whole["daily"][id]["sunset"];
      sunset =
          DateTime(1970, 01, 01).add(Duration(seconds: set_t + timeOffset));
      set_t = DateFormat.Hm().format(sunset).toString();

      riseset = rise_t + "/" + set_t;
    } else {
      // hour for 16 time step per hour

      av_temp = whole["hourly"][id]["temp"].round().toString();
      humidity = whole["hourly"][id]["humidity"].toString();
      weather = whole["hourly"][id]["weather"][0]["main"].toString();
      weather_path = "assets/images/$weather.png";
      var t = whole["hourly"][id]["dt"];
      currentTime =
          DateTime(1970, 01, 01).add(Duration(seconds: t + timeOffset));
      hour = DateFormat.H().format(currentTime);
    }
  }
}
