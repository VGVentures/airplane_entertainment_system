// ignore_for_file: prefer_const_constructors

import 'package:test/test.dart';
import 'package:weather_api_client/src/models/weather_information.dart';

void main() {
  group('$WeatherInformation', () {
    test('supports equality', () {
      expect(
        WeatherInformation(
          temperature: 70,
          condition: WeatherCondition.clear,
        ),
        equals(
          WeatherInformation(
            temperature: 70,
            condition: WeatherCondition.clear,
          ),
        ),
      );
    });
  });
}
