import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aweather_app/models/weather_model.dart';

class WeatherService {
  final String apiKey = '2227a0fd71a13c4ad28d92201d78a180';

  Future<Weather> fetchWeather(String cityName) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&units=metric&appid=$apiKey'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('City not Found');
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
