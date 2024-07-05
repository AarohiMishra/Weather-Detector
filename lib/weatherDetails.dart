import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_detector/Services/weatherServices.dart';
import 'package:weather_detector/weather_model.dart';
import 'dart:ui';

class WeatherHome extends StatefulWidget {
  final String cityName;
  WeatherHome({required this.cityName});

  @override
  State<StatefulWidget> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  late WeatherData weatherInfo;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize weather data with default values
    weatherInfo = WeatherData(
      name: '',
      temperature: Temperature(current: 0.0),
      humidity: 0,
      wind: Wind(speed: 0.0),
      maxTemperature: 0,
      minTemperature: 0,
      pressure: 0,
      seaLevel: 0,
      weather: [],
    );
    // Fetch weather data for the provided city
    myWeather(widget.cityName);
  }

  // Get the current temperature from the weather data
  double getCurrentTemperature() {
    return weatherInfo.temperature.current;
  }

  // Fetch weather data for a given city
  void myWeather(String cityName) {
    setState(() {
      isLoading = true;
    });

    WeatherServices().fetchWeather(cityName).then((value) {
      setState(() {
        weatherInfo = value;
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      showErrorSnackBar(cityName);
      print(error.toString());
    });
  }

  // Show an error snackbar if the city name is invalid
  void showErrorSnackBar(String cityName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(child: Text('Invalid city name: $cityName')),
        duration: Duration(seconds: 5),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Refresh weather data when the refresh button is pressed
  void _refreshData() {
    myWeather(widget.cityName);
  }

  @override
  Widget build(BuildContext context) {
    // Format current date and time
    String formattedDate =
        DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());

    // Determine background color based on the current temperature
    Color backgroundColor = getBackgroundColor(getCurrentTemperature());

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Text('Weather Details'),
            Spacer(),
            Container(
              height: 45,
              width: 2,
              color: Colors.black.withOpacity(0.2),
            ),
            IconButton(onPressed: _refreshData, icon: Icon(Icons.refresh)),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 0, left: 15, right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : WeatherDetail(
                      weather: weatherInfo,
                      formattedDate: formattedDate,
                      formattedTime: formattedTime,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Determine background color based on temperature range
  Color getBackgroundColor(double temperature) {
    if (temperature < 10) {
      return Colors.black54;
    } else if (temperature < 20) {
      return Colors.grey.shade600;
    } else if (temperature < 30) {
      return Colors.blue.shade700;
    } else if (temperature < 40) {
      return Colors.orange.shade300;
    } else if (temperature < 50) {
      return Colors.orange.shade500;
    } else {
      return Colors.yellow.shade800;
    }
  }
}

class WeatherDetail extends StatelessWidget {
  final WeatherData weather;
  final String formattedDate;
  final String formattedTime;

  const WeatherDetail({
    super.key,
    required this.weather,
    required this.formattedDate,
    required this.formattedTime,
  });

  @override
  Widget build(BuildContext context) {
    // Get the current sky condition
    String currentSky =
        weather.weather.isNotEmpty ? weather.weather[0].main : '';
    // Get the image path based on the current sky condition
    String imagePath = getImagePath(currentSky);

    return Column(
      children: [
        buildCityName(),
        buildTemperature(),
        if (weather.weather.isNotEmpty) buildWeatherDescription(),
        SizedBox(height: 15),
        buildFormattedDate(),
        buildFormattedTime(),
        SizedBox(height: 25),
        buildWeatherImage(imagePath),
        SizedBox(height: 25),
        buildWeatherInfoContainer(),
      ],
    );
  }

  // Build a container to display the city name
  Container buildCityName() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 2,
        ),
      ),
      padding: EdgeInsets.only(top: 4, bottom: 4, left: 30, right: 30),
      child: Text(
        weather.name,
        style: TextStyle(
          fontSize: 25,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Build a text widget to display the current temperature
  Text buildTemperature() {
    return Text(
      "${weather.temperature.current.toStringAsFixed(2)}°C",
      style: TextStyle(
        fontSize: 45,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Build a text widget to display the current weather description
  Text buildWeatherDescription() {
    return Text(
      weather.weather[0].main,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
    );
  }

  // Build a text widget to display the formatted date
  Text buildFormattedDate() {
    return Text(
      formattedDate,
      style: TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Build a text widget to display the formatted time
  Text buildFormattedTime() {
    return Text(
      formattedTime,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.white,
      ),
    );
  }

  // Build a container to display the weather image
  Container buildWeatherImage(String imagePath) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
        ),
      ),
    );
  }

  // Build a container to display additional weather information
  Container buildWeatherInfoContainer() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Row for displaying wind, max, and min temperature information
            buildWeatherInfoRow([
              buildWeatherInfoColumn(
                  Icons.wind_power, "Wind", "${weather.wind.speed} km/h"),
              buildWeatherInfoColumn(Icons.sunny, "Max",
                  "${weather.maxTemperature.toStringAsFixed(2)}℃"),
              buildWeatherInfoColumn(Icons.sunny, "Min",
                  "${weather.minTemperature.toStringAsFixed(2)}℃"),
            ]),
            const Divider(
              endIndent: 2,
              indent: 2,
              color: Colors.white,
              height: 5,
            ),
            // Row for displaying humidity, pressure, and sea-level information
            buildWeatherInfoRow([
              buildWeatherInfoColumn(
                  Icons.water_drop, "Humidity", "${weather.humidity}%"),
              buildWeatherInfoColumn(
                  Icons.air, "Pressure", "${weather.pressure}hPa"),
              buildWeatherInfoColumn(
                  Icons.leaderboard, "Sea-Level", "${weather.seaLevel}m"),
            ]),
          ],
        ),
      ),
    );
  }

  // Build a row of weather info columns
  Row buildWeatherInfoRow(List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }

  // Build a column for individual weather information
  Column buildWeatherInfoColumn(IconData icon, String title, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(height: 5),
        weatherInfoCard(title: title, value: value),
      ],
    );
  }

  // Build a card to display weather information
  Column weatherInfoCard({required String title, required String value}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  // Get the image path based on the current sky condition
  String getImagePath(String currentSky) {
    switch (currentSky) {
      case 'Clouds':
        return "assets/images/cloudy3.png";
      case 'Clear':
        return "assets/images/sunny.png";
      case 'Rain':
        return "assets/images/rainy.png";
      case 'Haze':
        return "assets/images/haze.png";
      case 'Mist':
        return "assets/images/mist.png";
      case 'Drizzle':
        return "assets/images/drizzle.png";
      case 'Fog':
        return "assets/images/fog.png";
      case 'Snow':
        return "assets/images/snow.png";
      default:
        return "assets/images/default.png";
    }
  }
}
