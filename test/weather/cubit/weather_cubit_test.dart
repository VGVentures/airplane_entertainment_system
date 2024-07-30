import 'package:airplane_entertainment_system/weather/weather.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_repository/weather_repository.dart';

import '../../helpers/pump_experience.dart';

void main() {
  group('WeatherCubit', () {
    late WeatherRepository weatherRepository;

    setUp(() {
      weatherRepository = MockWeatherRepository();
      when(() => weatherRepository.weather).thenReturn(
        const WeatherInfo(
          temperature: 70,
          condition: WeatherCondition.clear,
        ),
      );
      when(() => weatherRepository.weatherStream).thenAnswer(
        (_) => const Stream.empty(),
      );
    });

    WeatherCubit build() => WeatherCubit(
          weatherRepository: weatherRepository,
        );

    blocTest<WeatherCubit, WeatherInfo?>(
      'initial state is null',
      build: build,
      verify: (cubit) => expect(cubit.state, isNull),
    );

    blocTest<WeatherCubit, WeatherInfo?>(
      'updates [OverviewState.weatherInfo] when weather changes',
      setUp: () {
        when(() => weatherRepository.weatherStream).thenAnswer(
          (_) => Stream.fromIterable(
            [
              const WeatherInfo(
                temperature: 68,
                condition: WeatherCondition.rainy,
              ),
            ],
          ),
        );
      },
      build: build,
      expect: () => [
        const WeatherInfo(
          temperature: 68,
          condition: WeatherCondition.rainy,
        ),
      ],
    );

    group('initialize', () {
      blocTest<WeatherCubit, WeatherInfo?>(
        'loads initial weather info',
        build: build,
        act: (cubit) => cubit.initialize(),
        expect: () => [
          const WeatherInfo(
            temperature: 70,
            condition: WeatherCondition.clear,
          ),
        ],
      );
    });
  });
}
