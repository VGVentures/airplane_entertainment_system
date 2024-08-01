import 'package:airplane_entertainment_system/weather/weather.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_repository/weather_repository.dart';

import '../../helpers/helpers.dart';

class _MockWeatherBloc extends MockBloc<WeatherEvent, WeatherState>
    implements WeatherBloc {}

void main() {
  group('WeatherClouds', () {
    late WeatherBloc weatherBloc;
    final cloudsFinder = find.byType(Clouds);

    setUp(() {
      weatherBloc = _MockWeatherBloc();
    });

    Widget subject() {
      return BlocProvider.value(
        value: weatherBloc,
        child: const WeatherClouds(
          count: 10,
          averageScale: 1,
          averageVelocity: 1,
        ),
      );
    }

    testWidgets('renders no clouds when weather is clear', (tester) async {
      when(() => weatherBloc.state).thenReturn(
        const WeatherState(
          weatherInfo: WeatherInformation(
            temperature: 70,
            condition: WeatherCondition.clear,
          ),
          status: WeatherStatus.updating,
        ),
      );
      await tester.pumpApp(subject());

      expect(cloudsFinder, findsOneWidget);
      final clouds = tester.widget<Clouds>(cloudsFinder);
      expect(clouds.style, equals(CloudStyle.none));
    });

    testWidgets('renders light clouds when weather is cloudy', (tester) async {
      when(() => weatherBloc.state).thenReturn(
        const WeatherState(
          weatherInfo: WeatherInformation(
            temperature: 70,
            condition: WeatherCondition.cloudy,
          ),
          status: WeatherStatus.updating,
        ),
      );
      await tester.pumpApp(subject());

      expect(cloudsFinder, findsOneWidget);
      final clouds = tester.widget<Clouds>(cloudsFinder);
      expect(clouds.style, equals(CloudStyle.light));
    });

    testWidgets('renders medium clouds when weather is rainy', (tester) async {
      when(() => weatherBloc.state).thenReturn(
        const WeatherState(
          weatherInfo: WeatherInformation(
            temperature: 70,
            condition: WeatherCondition.rainy,
          ),
          status: WeatherStatus.updating,
        ),
      );
      await tester.pumpApp(subject());

      expect(cloudsFinder, findsOneWidget);
      final clouds = tester.widget<Clouds>(cloudsFinder);
      expect(clouds.style, equals(CloudStyle.medium));
    });

    testWidgets('renders dark clouds when weather is thunderstorms',
        (tester) async {
      when(() => weatherBloc.state).thenReturn(
        const WeatherState(
          weatherInfo: WeatherInformation(
            temperature: 70,
            condition: WeatherCondition.thunderstorms,
          ),
          status: WeatherStatus.updating,
        ),
      );
      await tester.pumpApp(subject());

      expect(cloudsFinder, findsOneWidget);
      final clouds = tester.widget<Clouds>(cloudsFinder);
      expect(clouds.style, equals(CloudStyle.dark));
    });
  });
}
