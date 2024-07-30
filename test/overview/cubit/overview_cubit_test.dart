import 'package:airplane_entertainment_system/overview/cubit/overview_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_repository/weather_repository.dart';

import '../../helpers/pump_experience.dart';

void main() {
  group('OverviewCubit', () {
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

    OverviewCubit build() => OverviewCubit(
          weatherRepository: weatherRepository,
        );

    blocTest<OverviewCubit, OverviewState>(
      'initial state is default [OverviewState]',
      build: build,
      verify: (cubit) => expect(
        cubit.state,
        const OverviewState(),
      ),
    );

    blocTest<OverviewCubit, OverviewState>(
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
        const OverviewState(
          weatherInfo: WeatherInfo(
            temperature: 68,
            condition: WeatherCondition.rainy,
          ),
        ),
      ],
    );

    group('initialize', () {
      blocTest<OverviewCubit, OverviewState>(
        'loads initial weather info',
        build: build,
        act: (cubit) => cubit.initialize(),
        expect: () => [
          const OverviewState(
            weatherInfo: WeatherInfo(
              temperature: 70,
              condition: WeatherCondition.clear,
            ),
          ),
        ],
      );
    });
  });
}
