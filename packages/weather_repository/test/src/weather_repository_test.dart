// ignore_for_file: prefer_const_constructors
import 'dart:math';

import 'package:fake_async/fake_async.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:weather_repository/weather_repository.dart';

class _MockRandom extends Mock implements Random {}

void main() {
  group('WeatherRepository', () {
    test('can be instantiated', () {
      expect(WeatherRepository(), isNotNull);
    });

    group('weather', () {
      test('returns a [WeatherInfo]', () async {
        final repository = WeatherRepository();
        expect(repository.weather, isA<WeatherInfo>());
      });
    });

    group('weatherStream', () {
      test(
          'emits a [WeatherInfo] after a random interval, '
          'no longer than 75 seconds', () async {
        fakeAsync((async) {
          final repository = WeatherRepository();
          final stream = repository.weatherStream;
          expect(stream.first, completion(isA<WeatherInfo>()));
          async.elapse(Duration(seconds: 75));
        });
      });
    });

    group('nextWeatherInfo', () {
      late Random random;

      setUp(() {
        random = _MockRandom();
      });

      test('returns random [WeatherInfo] when current condition is null', () {
        when(() => random.nextInt(any())).thenReturn(2);
        final repository = WeatherRepository(random: random);

        final next = repository.nextWeatherInfo();
        expect(next, weatherInfos[2]);
      });

      test('returns second [WeatherInfo] when current is first one', () {
        final repository = WeatherRepository();
        final previous = weatherInfos.first;
        final next = repository.nextWeatherInfo(previous);
        expect(next, weatherInfos[1]);
      });

      test(
          'returns first [WeatherInfo] when current is second one and random '
          'returns 0', () {
        when(() => random.nextInt(any())).thenReturn(0);
        final repository = WeatherRepository(random: random);
        final previous = weatherInfos[1];
        final next = repository.nextWeatherInfo(previous);
        expect(next, weatherInfos.first);
      });

      test(
          'returns third [WeatherInfo] when current is second one and random '
          'returns 1', () {
        when(() => random.nextInt(any())).thenReturn(1);
        final repository = WeatherRepository(random: random);
        final previous = weatherInfos[1];
        final next = repository.nextWeatherInfo(previous);
        expect(next, weatherInfos[2]);
      });

      test('returns second to last [WeatherInfo] when current is last one', () {
        final repository = WeatherRepository();
        final previous = weatherInfos.last;
        final next = repository.nextWeatherInfo(previous);
        expect(next, weatherInfos[weatherInfos.length - 2]);
      });
    });
  });
}
