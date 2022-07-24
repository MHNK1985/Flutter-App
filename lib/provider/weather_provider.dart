import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rocket_weather/models/searched_weather_model.dart';
import 'dart:convert';

import '../models/weather.dart';
import '../models/daily_weather.dart';

class WeatherProvider with ChangeNotifier {
  String apiKey = '8e9ebe2fa782486a90575021221907';
  Weather weather = Weather.defaultWeather();
  List<SearchedWeatherModel> searchedWeatherModel = [];
  DailyWeather currentWeather = DailyWeather();
  List<DailyWeather> hourlyWeather = [];
  List<DailyWeather> hourly24Weather = [];
  List<DailyWeather> fiveDayWeather = [];
  List<DailyWeather> lastThreeDays = [];
  List<DailyWeather> sevenDayWeather = [];
  bool loading = false;

  bool isRequestError = false;

  getWeatherData({String cityName = 'Tehran'}) async {
    loading = true;
    isRequestError = false;

    Uri dailyUrl = Uri.parse(
        'http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$cityName&days=7');
    await _getCurrentWeather(dailyUrl);
  }

  Future<List<SearchedWeatherModel>> searchCity({String cityName = ''}) async {
    isRequestError = false;

    Uri url = Uri.parse(
        'http://api.weatherapi.com/v1/search.json?key=$apiKey&q=$cityName');
    try {
      if (cityName.isEmpty) {
      } else {
        loading = true;

        final response = await http.get(url);
        final extractedData = json.decode(response.body).toList();
        searchedWeatherModel = SearchedWeatherModel.fromJsonList(extractedData);
      }

      return searchedWeatherModel;
    } catch (error) {
      loading = false;
      isRequestError = true;
      notifyListeners();
      return [];
    } finally {
      loading = false;
    }
  }

  Future<void> _getCurrentWeather(Uri url) async {
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      weather = Weather.fromJson(extractedData);
      currentWeather = DailyWeather.fromJson(extractedData);
      List<DailyWeather> tempHourly = [];
      List<DailyWeather> temp24Hour = [];
      List<DailyWeather> temp3days = [];
      // List<DailyWeather> tempSevenDay = [];
      List itemsHourly = extractedData['forecast']['forecastday'][0]['hour'];
      tempHourly = itemsHourly
          .map((item) => DailyWeather.fromHourlyJson(item))
          .toList()
          .reversed
          .skip(1)
          .take(3)
          .toList();
      temp24Hour = itemsHourly
          .map((item) => DailyWeather.fromHourlyJson(item))
          .toList()
          .reversed
          .skip(1)
          .take(24)
          .toList();
      itemsHourly.where((element) => element);

      temp3days.add(DailyWeather.fromHourlyJson(
          extractedData['forecast']['forecastday'][0]['hour'][0]));
      temp3days.add(DailyWeather.fromHourlyJson(
          extractedData['forecast']['forecastday'][1]['hour'][0]));
      temp3days.add(DailyWeather.fromHourlyJson(
          extractedData['forecast']['forecastday'][2]['hour'][0]));

      hourlyWeather = tempHourly;
      hourly24Weather = temp24Hour;
      lastThreeDays = temp3days;

      loading = false;
      notifyListeners();
    } catch (error) {
      loading = false;
      isRequestError = true;
      notifyListeners();
    }
  }
}
