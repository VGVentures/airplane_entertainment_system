// ignore_for_file: prefer_const_constructors
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:weather_api_client/weather_api_client.dart';
import 'package:weather_repository/weather_repository.dart';

class _MockWeatherApiClient extends Mock implements WeatherApiClient {}

void main() {
  group('$WeatherRepository', () {
    late WeatherApiClient weatherApiClient;

    setUp(() {
      weatherApiClient = _MockWeatherApiClient();
    });

    test('can be instantiated', () {
      expect(WeatherRepository(weatherApiClient), isNotNull);
    });

    group('weatherInformation', () {
      test('emits WeatherInformation updates', () {
        when(() => weatherApiClient.weatherInformation).thenAnswer(
          (_) => Stream.fromIterable(
            [
              WeatherInformation(
                temperature: 70,
                condition: WeatherCondition.clear,
              ),
            ],
          ),
        );

        final repository = WeatherRepository(weatherApiClient);
        final stream = repository.weatherInformation;

        expect(stream.first, completion(isA<WeatherInformation>()));
      });
    });
  });
}
