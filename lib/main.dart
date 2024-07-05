import 'package:flutter/material.dart'; // Importing the Flutter material design package
import 'package:weather_detector/splash.dart'; // Importing the custom splash screen widget

void main() {
  runApp(MyApp()); // The entry point of the application
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(), // Setting the Splash widget as the home screen of the app
    );
  }
}
