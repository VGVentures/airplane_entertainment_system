import 'package:airplane_entertainment_system/weather/weather.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_repository/weather_repository.dart';

import '../../helpers/pump_experience.dart';

void main() {
  group('WeatherBloc', () {
    late WeatherRepository weatherRepository;

    setUp(() {
      weatherRepository = MockWeatherRepository();
      when(() => weatherRepository.weatherInformation).thenAnswer(
        (_) => const Stream.empty(),
      );
    });

    test('can be instantiated', () {
      expect(
        WeatherBloc(
          weatherRepository: weatherRepository,
        ),
        isNotNull,
      );
    });

    group('WeatherUpdatesRequested', () {
      blocTest<WeatherBloc, WeatherState>(
        'updates state when weather changes',
        setUp: () {
          when(() => weatherRepository.weatherInformation).thenAnswer(
            (_) => Stream.fromIterable(
              [
                const WeatherInformation(
                  temperature: 70,
                  condition: WeatherCondition.clear,
                ),
              ],
            ),
          );
        },
        build: () => WeatherBloc(
          weatherRepository: weatherRepository,
        ),
        act: (bloc) => bloc.add(const WeatherUpdatesRequested()),
        expect: () => [
          const WeatherState(
            weatherInfo: WeatherInformation(
              temperature: 70,
              condition: WeatherCondition.clear,
            ),
            status: WeatherStatus.updating,
          ),
        ],
      );

      blocTest<WeatherBloc, WeatherState>(
        'emits error status when an error occurs',
        build: () {
          when(() => weatherRepository.weatherInformation).thenAnswer(
            (_) => Stream.error(Exception('oops')),
          );
          return WeatherBloc(
            weatherRepository: weatherRepository,
          );
        },
        act: (bloc) => bloc.add(const WeatherUpdatesRequested()),
        expect: () => [
          const WeatherState(
            status: WeatherStatus.error,
          ),
        ],
      );
    });
  });
}
