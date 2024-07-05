import 'dart:convert'; // Importing the 'dart:convert' library to handle JSON encoding and decoding
import 'package:http/http.dart'
    as http; // Importing the 'http' package for making HTTP requests
import 'package:weather_detector/weather_model.dart'; // Importing a custom model class for weather data

class WeatherServices {
  final String apiKey =
      'f3bda4ff9df3b42d530103bf0c994bd5'; // API key for accessing the OpenWeatherMap service
  // Function to fetch weather data for a given city
  Future<WeatherData> fetchWeather(String cityName) async {
    // Constructing the URL for the API request
    final Uri uri = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric");

    try {
      // Making the HTTP GET request
      final response = await http.get(uri);

      // Checking if the request was successful
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body); // Decoding the JSON response body
        return WeatherData.fromJson(
            json); // Returning a WeatherData object created from the JSON data
      } else {
        // If the request was not successful, printing error details and throwing an exception
        print(
            'Failed to load Weather Data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load Weather Data');
      }
    } catch (e) {
      // Catching and printing any errors that occur during the HTTP request
      print('Error fetching weather data: $e');
      throw Exception('Failed to load Weather Data');
    }
  }
}
