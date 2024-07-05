import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_detector/weatherDetails.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // TextEditingController to manage city name input
  TextEditingController cityName = TextEditingController();
  // Variable to store the last searched city
  String lastSearchedCity = '';

  @override
  void initState() {
    super.initState();
    _loadLastSearchedCity(); // Load the last searched city when the screen initializes
  }

  @override
  void dispose() {
    cityName.dispose(); // Dispose the controller to avoid memory leaks
    super.dispose();
  }

  // Method to load the last searched city from shared preferences
  Future<void> _loadLastSearchedCity() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lastSearchedCity = prefs.getString('lastSearchedCity') ??
          ''; // Set the last searched city
    });
  }

  // Method to save the last searched city to shared preferences
  Future<void> _saveLastSearchedCity(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastSearchedCity', cityName); // Save the city name
    await _addRecentSearch(cityName); // Add the city to recent searches
    setState(() {
      lastSearchedCity = cityName; // Update the last searched city state
    });
  }

  // Method to add a city to recent searches
  Future<void> _addRecentSearch(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recentSearches = prefs.getStringList('recentSearches') ??
        []; // Get the recent searches list
    recentSearches
        .remove(cityName); // Remove if already in the list to avoid duplicates
    recentSearches.insert(0, cityName); // Add to the top of the list
    if (recentSearches.length > 10) {
      recentSearches =
          recentSearches.sublist(0, 10); // Keep only the latest 10 searches
    }
    await prefs.setStringList('recentSearches',
        recentSearches); // Save the updated recent searches list
  }

  // Method to get recent searches from shared preferences
  Future<List<String>> _getRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('recentSearches') ??
        []; // Return the recent searches list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.home, color: Colors.grey.shade800),
            SizedBox(width: 8),
            Text('Home'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate:
                    CitySearchDelegate(_getRecentSearches, _addRecentSearch),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/mainPage/main.jpg'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                // Top icons container
                Container(
                  width: 370,
                  height: 213,
                  decoration: BoxDecoration(
                    color: Colors.black
                        .withOpacity(0.5), // Semi-transparent background
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // First row of icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.wind_power,
                              color: Colors.white.withOpacity(0.5), size: 40),
                          Icon(Icons.ac_unit,
                              color: Colors.white.withOpacity(0.5), size: 40),
                          Icon(Icons.water,
                              color: Colors.white.withOpacity(0.5), size: 40),
                          Icon(Icons.snowing,
                              color: Colors.white.withOpacity(0.5), size: 40),
                        ],
                      ),
                      // Second row of icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.cloud,
                              color: Colors.white.withOpacity(0.5), size: 40),
                          Icon(Icons.webhook_outlined,
                              color: Colors.white.withOpacity(0.5), size: 40),
                          Icon(Icons.backup_outlined,
                              color: Colors.white.withOpacity(0.5), size: 40),
                          Icon(Icons.bathroom_outlined,
                              color: Colors.white.withOpacity(0.5), size: 40),
                        ],
                      ),
                      // Third row of icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.sunny,
                              color: Colors.white.withOpacity(0.5), size: 40),
                          Icon(Icons.broadcast_on_home_sharp,
                              color: Colors.white.withOpacity(0.5), size: 40),
                          Icon(Icons.bar_chart_outlined,
                              color: Colors.white.withOpacity(0.5), size: 40),
                          Icon(Icons.cloudy_snowing,
                              color: Colors.white.withOpacity(0.5), size: 40),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                // City input container
                Container(
                  width: 370,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.black
                        .withOpacity(0.5), // Semi-transparent background
                    borderRadius: BorderRadius.all(
                        Radius.circular(10)), // Rounded corners
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          'City Name:',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: 350,
                        child: TextField(
                          controller: cityName,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Enter the name of the city',
                            labelStyle: TextStyle(
                                color: Colors.grey.shade300, fontSize: 18),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(21),
                            ),
                            prefixIcon: Icon(
                              Icons.add_location,
                              color: Colors.grey.shade300.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () async {
                          String cityNameLocation =
                              cityName.text.trim(); // Get the input city name
                          if (cityNameLocation.isNotEmpty) {
                            await _saveLastSearchedCity(
                                cityNameLocation); // Save the city name
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WeatherHome(
                                    cityName:
                                        cityNameLocation), // Navigate to WeatherHome
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Please fill the City Name')), // Show error message
                            );
                          }
                          cityName.clear(); // Clear the input field
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        child: Text('Check'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                // Bottom icons container
                Container(
                  width: 370,
                  height: 213,
                  decoration: BoxDecoration(
                    color: Colors.black
                        .withOpacity(0.5), // Semi-transparent background
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ), // Rounded corners
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // First row of icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.ac_unit,
                              color: Colors.white.withOpacity(0.5), size: 40),
                          Icon(Icons.cloud,
                              color: Colors.white.withOpacity(0.5), size: 40),
                          Icon(Icons.webhook_outlined,
                              color: Colors.white.withOpacity(0.5), size: 40),
                          Icon(Icons.broadcast_on_home_sharp,
                              color: Colors.white.withOpacity(0.5), size: 40),
                        ],
                      ),
                      // Second row of icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.snowing,
                              color: Colors.white.withOpacity(0.5), size: 40),
                          Icon(Icons.water,
                              color: Colors.white.withOpacity(0.5), size: 40),
                          Icon(Icons.wind_power,
                              color: Colors.white.withOpacity(0.5), size: 40),
                          Icon(Icons.bathroom_outlined,
                              color: Colors.white.withOpacity(0.5), size: 40),
                        ],
                      ),
                      // Third row of icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.sunny,
                              color: Colors.white.withOpacity(0.5), size: 40),
                          Icon(Icons.backup_outlined,
                              color: Colors.white.withOpacity(0.5), size: 40),
                          Icon(Icons.account_tree_outlined,
                              color: Colors.white.withOpacity(0.5), size: 40),
                          Icon(Icons.cloudy_snowing,
                              color: Colors.white.withOpacity(0.5), size: 40),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CitySearchDelegate extends SearchDelegate<String> {
  final Future<List<String>> Function() getRecentSearches;
  final Future<void> Function(String) addRecentSearch;

  CitySearchDelegate(this.getRecentSearches, this.addRecentSearch);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the search query
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // Close the search bar
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(); // Empty container as we don't need to show results here
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return FutureBuilder<List<String>>(
        future: getRecentSearches(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator()); // Show loading indicator
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}')); // Show error message
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(
                    'No recent searches')); // Show message if no recent searches
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final String city = snapshot.data![index]; // Get the city name
                return ListTile(
                  title: Text(city),
                  onTap: () async {
                    await addRecentSearch(
                        city); // Add the city to recent searches
                    close(context, city); // Close the search bar
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WeatherHome(
                            cityName: city), // Navigate to WeatherHome
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      );
    } else {
      return FutureBuilder<List<String>>(
        future: _fetchCityNames(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator()); // Show loading indicator
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}')); // Show error message
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(
                    'No city names found')); // Show message if no city names found
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final String city = snapshot.data![index]; // Get the city name
                return ListTile(
                  title: Text(city),
                  onTap: () async {
                    await addRecentSearch(
                        city); // Add the city to recent searches
                    close(context, city); // Close the search bar
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WeatherHome(
                            cityName: city), // Navigate to WeatherHome
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      );
    }
  }

  // Method to fetch city names based on the query from OpenWeatherMap API
  Future<List<String>> _fetchCityNames(String query) async {
    final String apiKey = 'f3bda4ff9df3b42d530103bf0c994bd5';
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/find?q=$query&type=like&appid=$apiKey&units=metric"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> cities = data['list'];
      return cities
          .map((city) => city['name'] as String)
          .toList(); // Return list of city names
    } else {
      throw Exception('Failed to load city names');
    }
  }
}

class WeatherDetailsScreen extends StatelessWidget {
  final String cityName;

  const WeatherDetailsScreen({Key? key, required this.cityName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Details'),
      ),
      body: FutureBuilder(
        future: _fetchWeatherData(cityName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(), // Show loading indicator
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'), // Show error message
            );
          } else {
            return Center(
              child: Text(
                  'Weather Details Loaded for $cityName'), // Show weather details
            );
          }
        },
      ),
    );
  }

  // Method to fetch weather data (simulated delay for now)
  Future<String> _fetchWeatherData(String cityName) async {
    // Simulating a delay of 2 seconds to fetch weather data
    await Future.delayed(Duration(seconds: 2));
    return 'Weather data for $cityName';
  }
}
