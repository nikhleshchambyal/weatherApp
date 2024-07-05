import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aweather_app/services/weather_service.dart';
import 'package:aweather_app/screens/weather_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _cityController = TextEditingController();
  bool _isLoading = false;

  void _searchWeather(BuildContext context) async {
    final cityName = _cityController.text;
    if (cityName.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final weather = await Provider.of<WeatherService>(context, listen: false)
          .fetchWeather(cityName);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('lastSearchedCity', cityName);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherDetailsScreen(weather: weather),
        ),
      );
    } catch (e) {
      String errorMessage = e.toString();
      String finalMessage = errorMessage.substring(11);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(finalMessage)));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadLastSearchedCity();
  }

  void _loadLastSearchedCity() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSearchedCity = prefs.getString('lastSearchedCity');
    if (lastSearchedCity != null) {
      _cityController.text = lastSearchedCity;
      _searchWeather(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Enter city name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => _searchWeather(context),
                    child: Text('Search'),
                  ),
          ],
        ),
      ),
    );
  }
}
