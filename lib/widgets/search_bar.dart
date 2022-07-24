import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../models/searched_weather_model.dart';
import '../provider/weather_provider.dart';

class SearchBar extends StatefulWidget {
  final WeatherProvider wData;
  const SearchBar({Key? key, required this.wData}) : super(key: key);

  @override
  SearchBarState createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 25,
        horizontal: MediaQuery.of(context).size.width * .05,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 15,
            offset: const Offset(8, 6),
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: TypeAheadField<SearchedWeatherModel>(
        textFieldConfiguration: TextFieldConfiguration(
            autofocus: false,
            style: DefaultTextStyle.of(context)
                .style
                .copyWith(fontStyle: FontStyle.italic),
            decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search), border: InputBorder.none)),
        suggestionsCallback: (pattern) async {
          return await widget.wData.searchCity(cityName: pattern);
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            leading: const Icon(Icons.location_city),
            title: Text(suggestion.name),
          );
        },
        onSuggestionSelected: (suggestion) {
          widget.wData.getWeatherData(cityName: suggestion.name);
          _textController.clear();
        },
      ),
    );
  }
}
