// ignore_for_file: prefer_const_constructors

import 'package:airplane_entertainment_system/weather/weather.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('$WeatherEvent', () {
    group('WeatherUpdatedRequested', () {
      test('supports value comparisons', () {
        expect(
          WeatherUpdatesRequested(),
          equals(WeatherUpdatesRequested()),
        );
      });
    });
  });
}
