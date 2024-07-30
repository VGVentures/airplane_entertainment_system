import 'package:airplane_entertainment_system/overview/cubit/overview_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_repository/weather_repository.dart';

class _MockWeatherInfo extends Mock implements WeatherInfo {}

void main() {
  group('OverviewState', () {
    group('supports value comparison', () {
      test('with equal instances', () {
        final info = _MockWeatherInfo();
        expect(
          OverviewState(weatherInfo: info),
          OverviewState(weatherInfo: info),
        );
      });

      test('with different instances', () {
        expect(
          OverviewState(weatherInfo: _MockWeatherInfo()),
          isNot(OverviewState(weatherInfo: _MockWeatherInfo())),
        );
      });
    });
  });
}
