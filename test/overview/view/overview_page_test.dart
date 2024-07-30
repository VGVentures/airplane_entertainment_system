import 'package:airplane_entertainment_system/overview/overview.dart';
import 'package:airplane_entertainment_system/weather/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_repository/weather_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('$OverviewPage', () {
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

    testWidgets('contains welcome copy', (tester) async {
      await tester.pumpApp(
        const OverviewPage(),
        weatherRepository: weatherRepository,
      );

      expect(find.byType(WelcomeCopy), findsOneWidget);
    });

    testWidgets('contains flight tracker', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1600, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpApp(
        const OverviewPage(),
        weatherRepository: weatherRepository,
      );

      await tester.dragUntilVisible(
        find.byType(FlightTrackingCard),
        find.byType(ListView),
        const Offset(0, -50),
      );

      expect(find.byType(FlightTrackingCard), findsOneWidget);
    });

    testWidgets('contains weather card', (tester) async {
      await tester.pumpApp(
        const OverviewPage(),
        weatherRepository: weatherRepository,
      );

      final finder = find.byType(WeatherCard);
      await tester.scrollUntilVisible(finder, 100);

      expect(finder, findsOneWidget);
    });
  });
}
