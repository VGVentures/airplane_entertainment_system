// ignore_for_file: prefer_const_constructors

import 'package:test/test.dart';
import 'package:weather_repository/weather_repository.dart';

void main() {
  group('WeatherInfo', () {
    group('supports value comparison', () {
      test('with equal instances', () {
        expect(
          WeatherInfo(temperature: 70, condition: WeatherCondition.clear),
          WeatherInfo(temperature: 70, condition: WeatherCondition.clear),
        );
      });

      test('with different instances', () {
        expect(
          WeatherInfo(temperature: 70, condition: WeatherCondition.clear),
          isNot(
            WeatherInfo(temperature: 68, condition: WeatherCondition.cloudy),
          ),
        );
      });
    });
  });
}
