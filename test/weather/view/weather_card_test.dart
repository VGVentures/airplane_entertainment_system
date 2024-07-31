import 'package:airplane_entertainment_system/weather/weather.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_repository/weather_repository.dart';

import '../../helpers/pump_experience.dart';
import '../../helpers/tester_l10n.dart';

class _MockWeatherCubit extends MockBloc<WeatherEvent, WeatherState>
    implements WeatherBloc {}

void main() {
  group('$WeatherCard', () {
    final weatherInformation = [
      const WeatherInformation(
        temperature: 70,
        condition: WeatherCondition.clear,
      ),
      const WeatherInformation(
        temperature: 68,
        condition: WeatherCondition.cloudy,
      ),
      const WeatherInformation(
        temperature: 66,
        condition: WeatherCondition.rainy,
      ),
      const WeatherInformation(
        temperature: 64,
        condition: WeatherCondition.thunderstorms,
      ),
    ];

    late WeatherBloc weatherBloc;

    setUp(() {
      weatherBloc = _MockWeatherCubit();
    });

    testWidgets('renders a loading indicator when status is initial',
        (tester) async {
      when(() => weatherBloc.state).thenReturn(const WeatherState());

      await tester.pumpApp(
        BlocProvider.value(
          value: weatherBloc,
          child: const WeatherCardView(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders a error message when status is initial',
        (tester) async {
      when(() => weatherBloc.state).thenReturn(
        const WeatherState(
          status: WeatherStatus.error,
        ),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: weatherBloc,
          child: const WeatherCardView(),
        ),
      );

      expect(find.text(tester.l10n.weatherErrorMessage), findsOneWidget);
    });

    for (final information in weatherInformation) {
      testWidgets('renders a ${information.condition} weather card',
          (tester) async {
        when(() => weatherBloc.state).thenReturn(
          WeatherState(
            weatherInfo: information,
            status: WeatherStatus.updating,
          ),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: weatherBloc,
            child: const WeatherCardView(),
          ),
        );

        expect(find.text('${information.temperature}°'), findsOneWidget);
        expect(
          find.text(information.conditionLabel(tester.l10n)),
          findsOneWidget,
        );
      });
    }
  });
}
