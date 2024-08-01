import 'package:airplane_entertainment_system/flight_tracking/flight_tracking.dart';
import 'package:airplane_entertainment_system/overview/overview.dart';
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
  group('$OverviewPage', () {
    late WeatherBloc weatherBloc;

    Widget subject() {
      return BlocProvider.value(
        value: weatherBloc,
        child: const OverviewPage(),
      );
    }

    setUp(() {
      weatherBloc = _MockWeatherBloc();
      when(() => weatherBloc.state).thenReturn(
        const WeatherState(
          weatherInfo: WeatherInformation(
            temperature: 70,
            condition: WeatherCondition.clear,
          ),
          status: WeatherStatus.updating,
        ),
      );
    });

    testWidgets('contains welcome copy', (tester) async {
      await tester.pumpApp(subject());

      expect(find.byType(WelcomeCopy), findsOneWidget);
    });

    testWidgets('contains flight tracker', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1600, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpApp(subject());

      await tester.dragUntilVisible(
        find.byType(FlightTrackingCard),
        find.byType(ListView),
        const Offset(0, -50),
      );

      expect(find.byType(FlightTrackingCard), findsOneWidget);
    });

    testWidgets('contains weather card', (tester) async {
      await tester.pumpApp(subject());

      final finder = find.byType(WeatherCard);
      await tester.scrollUntilVisible(finder, 100);

      expect(finder, findsOneWidget);
    });
  });
}
