import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/models/weather.dart';

void main() {
  group('Weather Model Test', () {
    test('should return a valid Weather model from a realistic Manila JSON response', () {
      // 1. Arrange: Realistic Manila JSON data from OpenWeatherMap
      final Map<String, dynamic> jsonMap = {
        "weather": [
          {
            "main": "Clouds",
            "description": "broken clouds",
          }
        ],
        "main": {
          "temp": 29.5,
          "humidity": 65
        },
        "wind": {"speed": 4.12},
        "name": "Manila",
      };

      // 2. Act: Call the fromJson factory
      final result = Weather.fromJson(jsonMap);

      // 3. Assert: Matching the fields in your lib/models/weather.dart
      expect(result.city, 'Manila');
      expect(result.temperature, 29.5);
      expect(result.description, 'Clouds');
      expect(result.humidity, 65);
      expect(result.windSpeed, 4.12);
    });

    test('should handle integer temperatures and wind speeds correctly', () {
      // Testing the (as num).toDouble() logic in your model
      final Map<String, dynamic> jsonMap = {
        "weather": [{"main": "Clear"}],
        "main": {
          "temp": 30, // integer
          "humidity": 70
        },
        "wind": {"speed": 5}, // integer
        "name": "Manila"
      };

      final result = Weather.fromJson(jsonMap);

      expect(result.temperature, 30.0);
      expect(result.windSpeed, 5.0);
    });
  });
}
