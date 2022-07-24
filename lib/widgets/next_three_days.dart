import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helper/utils.dart';
import '../models/daily_weather.dart';

class NextThreeDays extends StatelessWidget {
  final List<DailyWeather> nextThreeDaysForecast;

  const NextThreeDays(this.nextThreeDaysForecast, {Key? key}) : super(key: key);

  Widget hourlyWidget(DailyWeather weather, BuildContext context) {
    final currentTime = weather.date;
    final hours = DateFormat('yyyy-MM-dd').format(currentTime!);

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(6, 8),
          ),
        ],
      ),
      height: 175,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  hours,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: MapString.mapStringToIcon(
                      '${weather.condition}', context, 40),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    "${weather.dailyTemp!.toStringAsFixed(1)}°C",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  'Next 3 Days',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: nextThreeDaysForecast
                  .map((item) => hourlyWidget(item, context))
                  .toList()),
        ],
      ),
    );
  }
}
