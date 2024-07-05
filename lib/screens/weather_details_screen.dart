import 'package:flutter/material.dart';
import 'package:aweather_app/models/weather_model.dart';
import 'package:provider/provider.dart';
import 'package:aweather_app/services/weather_service.dart';

class WeatherDetailsScreen extends StatelessWidget {
  final Weather weather;

  const WeatherDetailsScreen({super.key, required this.weather});

  void _refreshWeather(BuildContext context) async {
    try {
      final newWeather =
          await Provider.of<WeatherService>(context, listen: false)
              .fetchWeather(weather.cityName);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherDetailsScreen(weather: newWeather),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to fetch updated weather data')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(weather.cityName),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshWeather(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Temperature: ${weather.temperature} °C',
                style: const TextStyle(fontSize: 24)),
            Text('Condition: ${weather.description}',
                style: const TextStyle(fontSize: 24)),
            Image.network(
                'http://openweathermap.org/img/wn/${weather.icon}@2x.png'),
            Text('Humidity: ${weather.humidity}%',
                style: const TextStyle(fontSize: 24)),
            Text('Wind Speed: ${weather.windSpeed} m/s',
                style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
