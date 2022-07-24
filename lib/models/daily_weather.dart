import 'package:flutter/material.dart';

class DailyWeather with ChangeNotifier {
  num? dailyTemp;
  String? condition;
  DateTime? date;
  var precip;
  num? uvi;

  DailyWeather({
    this.dailyTemp,
    this.condition,
    this.date,
    this.precip,
    this.uvi,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    final precipData = json['current']['precip_mm'];
    final calcPrecip = precipData * 100;
    final precipitation = calcPrecip.toStringAsFixed(0);
    return DailyWeather(
      precip: precipitation,
      uvi: json['current']['uvi'],
    );
  }

  static DailyWeather fromDailyJson(dynamic json) {
    return DailyWeather(
      dailyTemp: json['avgtemp_c'],
      condition: json['condition']['text'],
      date: DateTime.fromMillisecondsSinceEpoch(json['date_epoch'] * 1000,
              isUtc: true)
          .toLocal(),
    );
  }

  static DailyWeather fromHourlyJson(dynamic json) {
    return DailyWeather(
      dailyTemp: json['temp_c'],
      condition: json['condition']['text'],
      date: DateTime.fromMillisecondsSinceEpoch(json['time_epoch'] * 1000,
              isUtc: true)
          .toLocal(),
    );
  }
}
