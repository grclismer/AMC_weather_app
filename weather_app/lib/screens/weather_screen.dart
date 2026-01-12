import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../services/weather_services.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  late Future<Weather> weatherFuture;

  @override
  void initState() {
    super.initState();
    // Initial city
    weatherFuture = WeatherServices.getWeather('Manila');
  }

  void _searchWeather() {
    final String city = _cityController.text.trim();
    if (city.isEmpty) return;

    setState(() {
      weatherFuture = WeatherServices.getWeather(city);
    });
    // Optional: Hide keyboard after search
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'WEATHER',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF08203E), // Midnight Blue
              Color(0xFF552586), // Royal Purple
              Color(0xFFB12A5B), // Deep Magenta
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 120, left: 24, right: 24),
          child: Column(
            children: [
              // ===== MODERN SEARCH BAR (Glassmorphism) =====
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: TextField(
                  controller: _cityController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search city...',
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
                      onPressed: _searchWeather,
                    ),
                  ),
                  onSubmitted: (_) => _searchWeather(),
                ),
              ),

              const SizedBox(height: 60),

              // ===== WEATHER DATA DISPLAY =====
              FutureBuilder<Weather>(
                future: weatherFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'City not found or error occurred',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  if (snapshot.hasData) {
                    final weather = snapshot.data!;
                    return Column(
                      children: [
                        // City Name
                        Text(
                          weather.city.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                            letterSpacing: 8,
                          ),
                        ),

                        // Exact Temperature (Decimals)
                        Text(
                          '${weather.temperature.toStringAsFixed(1)}°C',
                          style: const TextStyle(
                            fontSize: 85, // Adjusted size to fit the decimal and "C"
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        // Weather Condition Pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            weather.description.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ),

                        const SizedBox(height: 60),

                        // Glassmorphism Detail Card
                        Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildDetail(
                                Icons.opacity,
                                'HUMIDITY',
                                '${weather.humidity}%',
                              ),
                              _buildDetail(
                                Icons.air,
                                'WIND',
                                '${weather.windSpeed.toStringAsFixed(1)} km/h',
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable Detail Widget
  Widget _buildDetail(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 10),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
