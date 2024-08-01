// ignore_for_file: prefer_const_constructors
import 'dart:math';

import 'package:fake_async/fake_async.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:weather_api_client/weather_api_client.dart';

class _MockRandom extends Mock implements Random {}

void main() {
  group('WeatherApiClient', () {
    test('can be instantiated', () {
      expect(WeatherApiClient(), isNotNull);
    });

    group('weatherInformation', () {
      test('emits WeatherInformation updates', () {
        fakeAsync((async) {
          final client = WeatherApiClient();
          final updates = <WeatherInformation>[];

          client.weatherInformation.listen(updates.add);

          async.elapse(Duration(seconds: 90));

          expect(updates.length, equals(2));

          async.elapse(Duration(seconds: 90));

          expect(updates.length, equals(3));
        });
      });
    });

    group('nextWeatherInformation', () {
      late Random random;

      setUp(() {
        random = _MockRandom();
      });

      test('returns random [WeatherInfo] when current condition is null', () {
        when(() => random.nextInt(any())).thenReturn(2);

        final client = WeatherApiClient(random: random);

        final next = client.nextWeatherInformation();

        expect(next, equals(weatherInfos[2]));
      });

      test('returns second [WeatherInfo] when current is first one', () {
        final client = WeatherApiClient(random: random)
          ..lastWeatherInformation = weatherInfos.first;

        final next = client.nextWeatherInformation();

        expect(next, equals(weatherInfos[1]));
      });

      test(
          'returns first [WeatherInfo] when current is second one and random '
          'returns 0', () {
        when(() => random.nextInt(any())).thenReturn(0);

        final client = WeatherApiClient(random: random)
          ..lastWeatherInformation = weatherInfos[1];

        final next = client.nextWeatherInformation();

        expect(next, equals(weatherInfos.first));
      });

      test(
          'returns third [WeatherInfo] when current is second one and random '
          'returns 1', () {
        when(() => random.nextInt(any())).thenReturn(1);

        final client = WeatherApiClient(random: random)
          ..lastWeatherInformation = weatherInfos[1];

        final next = client.nextWeatherInformation();

        expect(next, equals(weatherInfos[2]));
      });

      test('returns second to last [WeatherInfo] when current is last one', () {
        final client = WeatherApiClient(random: random)
          ..lastWeatherInformation = weatherInfos.last;

        final next = client.nextWeatherInformation();

        expect(next, equals(weatherInfos[weatherInfos.length - 2]));
      });
    });

    group('dispose', () {
      test('closes the flightInformation stream', () async {
        final client = WeatherApiClient();
        final updates = <WeatherInformation>[];

        client.weatherInformation.listen(updates.add);

        await client.dispose();

        expect(updates.length, equals(1));
      });
    });
  });
}
