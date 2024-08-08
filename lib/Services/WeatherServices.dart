import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/WeatherDot.dart';
import 'package:http/http.dart' as http;




Image getWeatherIcon(String _icon) {
  String path = 'icons/';
  String imageExtension = ".png";
  return Image.assets(
    path + _icon + imageExtension,
    width: 70,
    height: 70,
  );
}

Image getWeatherIconSmall(String _icon) {
  String path = 'icons/';
  String imageExtension = ".png";
  return Image.asset(
    path + _icon + imageExtension,
    width: 40,
    height: 40,
  );
}

String getTimeFromTimestamp(int timestamp) {
  var date
  = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var formatter = DateFormat('h:mm a');
  return formatter.format(date);
}

String getDateFromTimestamp(int timestamp) {
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var formatter = DateFormat('E');
  return formatter.format(date);
}



Future<Weather> getCurrentWeather(Location location) async {
  Weather weather;
  String city = location.city;
  String apiKey = "9606444e75b0bd62e4fb9ede031a9d64";
  var url = "https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${apiKey}";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    weather = Weather.fromJSON(jsonDecode(response.body));
    return weather;
  } else {
    throw Exception('Failed to load weather data');
  }
}


Future getForecast(Location location) async {
  Forecast forecast;
  String apiKey = "9606444e75b0bd62e4fb9ede031a9d64";
  String lat = location.lat;
  String lon = location.long;

  var url =   "api.openweathermap.org/data/2.5/forecast/daily?lat=${lat}&lon=${lon}&cnt=4&appid=${apiKey}";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    forecast = Forecast.fromJson(jsonDecode(response.body));
    return forecast;
  }

}


