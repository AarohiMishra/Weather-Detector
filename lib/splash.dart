import 'package:flutter/material.dart';
import 'dart:async'; // Importing the dart:async package for Timer
import 'package:weather_detector/homeScreen.dart'; // Importing the home screen widget

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
      _SplashState(); // Creating the state for the Splash widget
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    // Setting up a timer to navigate to the home screen after 4 seconds
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomeScreen())); //For navigation to the HomeScreen page
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double
            .infinity, // Setting the width to the full width of the screen
        height: double
            .infinity, // Setting the height to the full height of the screen
        child: Stack(
          children: [
            Image.asset(
              'assets/splash/main.jpg', // Displaying the splash image
              fit: BoxFit.cover, // Covering the entire screen with the image
              height: double
                  .infinity, // Setting the height to the full height of the screen
              width: double
                  .infinity, // Setting the width to the full width of the screen
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 140), // Adding padding to position the text
              child: Center(
                child: Text(
                  'Weather Detector', // Displaying the app title
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
