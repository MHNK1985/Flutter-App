import 'dart:convert';

class SearchedWeatherModel {
  final int? id;
  final String name;
  final String? region;
  final String? country;
  final double? lat;
  final double? lon;
  final String? url;

  const SearchedWeatherModel({
    this.id,
    this.name = '',
    this.region,
    this.country,
    this.lat,
    this.lon,
    this.url,
  });

  factory SearchedWeatherModel.fromMap(Map<String, dynamic> data) =>
      SearchedWeatherModel(
        id: data['id'] as int?,
        name: data['name'],
        region: data['region'] as String?,
        country: data['country'] as String?,
        lat: (data['lat'] as num?)?.toDouble(),
        lon: (data['lon'] as num?)?.toDouble(),
        url: data['url'] as String?,
      );

  static List<SearchedWeatherModel> fromJsonList(List<dynamic> data) {
    if (data == null) return [];
    return data
        .map((e) => SearchedWeatherModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'region': region,
        'country': country,
        'lat': lat,
        'lon': lon,
        'url': url,
      };

  /// `dart:convert`
  ///
  /// Converts [SearchedWeatherModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
