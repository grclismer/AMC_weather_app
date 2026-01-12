import 'package:flutter/material.dart';
import 'screens/weather_screen.dart'; // Corrected path

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Changed to WeatherScreen to match your preferred naming
      home: const WeatherScreen(),
    );
  }
}
