class WeatherData {
  final String name; // Name of the city
  final Temperature
      temperature; // Temperature object containing current temperature
  final int humidity; // Humidity percentage
  final Wind wind; // Wind object containing wind speed
  final double maxTemperature; // Maximum temperature in Celsius
  final double minTemperature; // Minimum temperature in Celsius
  final int pressure; // Atmospheric pressure in hPa
  final int
      seaLevel; // Sea level pressure in hPa, with a default of 0 if not provide
  final List<WeatherInfo>
      weather; // List of WeatherInfo objects describing the weather conditions

  WeatherData({
    required this.name,
    required this.temperature,
    required this.humidity,
    required this.wind,
    required this.maxTemperature,
    required this.minTemperature,
    required this.pressure,
    required this.seaLevel,
    required this.weather,
  });

  // Factory constructor to create a WeatherData object from JSON data
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      name: json['name'], // City name
      temperature:
          Temperature.fromJson(json['main']['temp']), // Current temperature
      humidity: json['main']['humidity'], // Humidity percentage
      wind: Wind.fromJson(json['wind']), // Wind speed
      maxTemperature: json['main']['temp_max'], // Max temperature in Celsius
      minTemperature: json['main'][
          'temp_min'], // Min temperature in Celsius, Already in Celsius due to units=metric
      pressure: json['main']['pressure'], // Atmospheric pressure in hPa
      seaLevel: json['main']['sea_level'] ??
          0, // Sea level pressure in hPa, defaults to 0 if not provided
      weather: List<WeatherInfo>.from(
        json['weather'].map(
          (weather) =>
              WeatherInfo.fromJson(weather), // List of WeatherInfo objects
        ),
      ),
    );
  }
}

class WeatherInfo {
  final String main; // Main weather description

  WeatherInfo({
    required this.main,
  });

  // Factory constructor to create a WeatherInfo object from JSON data
  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    return WeatherInfo(
      main: json['main'], // Main weather description
    );
  }
}

class Temperature {
  final double current; // Current temperature

  Temperature({required this.current});

  // Factory constructor to create a Temperature object from JSON data
  factory Temperature.fromJson(dynamic json) {
    return Temperature(
      current: json.toDouble(), // Current temperature, ensuring it is a double
    );
  }
}

class Wind {
  final double speed; // Wind speed in meter/sec

  Wind({required this.speed});

  // Factory constructor to create a Wind object from JSON data
  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
        speed: json['speed'].toDouble()); // Wind speed, ensuring it is a double
  }
}
