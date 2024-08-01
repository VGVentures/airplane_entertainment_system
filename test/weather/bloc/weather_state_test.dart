// ignore_for_file: prefer_const_constructors

import 'package:airplane_entertainment_system/weather/weather.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('$WeatherState', () {
    test('supports value comparisons', () {
      expect(WeatherState(), equals(WeatherState()));
    });

    group('copyWith', () {
      test('returns same object when no properties are passed', () {
        expect(WeatherState().copyWith(), equals(WeatherState()));
      });
    });
  });
}
