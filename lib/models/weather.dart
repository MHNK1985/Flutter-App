import 'package:flutter/cupertino.dart';

class Weather with ChangeNotifier {
  final num temp;
  final num lat;
  final num long;
  final num feelsLike;
  final num pressure;
  final String currently;
  final num humidity;
  final num windSpeed;
  final String cityName;

  Weather({
    required this.temp,
    required this.lat,
    required this.long,
    required this.feelsLike,
    required this.pressure,
    required this.currently,
    required this.humidity,
    required this.windSpeed,
    required this.cityName,
  });

  factory Weather.defaultWeather() {
    return Weather(
      temp: 0,
      lat: 0,
      long: 0,
      feelsLike: 0,
      pressure: 0,
      currently: '',
      humidity: 0,
      windSpeed: 0,
      cityName: '',
    );
  }

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temp: json['current']['temp_c'],
      lat: json['location']['lat'],
      long: json['location']['lon'],
      feelsLike: json['current']['feelslike_c'],
      pressure: json['current']['pressure_in'],
      currently: json['current']['condition']['text'],
      humidity: json['current']['humidity'],
      windSpeed: json['current']['wind_kph'],
      cityName: json['location']['name'],
    );
  }
}
