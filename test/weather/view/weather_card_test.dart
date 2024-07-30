import 'package:airplane_entertainment_system/weather/weather.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weather_repository/weather_repository.dart';

import '../../helpers/pump_experience.dart';
import '../../helpers/tester_l10n.dart';

class _MockWeatherCubit extends MockCubit<WeatherInfo?>
    implements WeatherCubit {}

void main() {
  group('WeatherCard', () {
    final weatherInfo = [
      const WeatherInfo(
        temperature: 70,
        condition: WeatherCondition.clear,
      ),
      const WeatherInfo(
        temperature: 68,
        condition: WeatherCondition.cloudy,
      ),
      const WeatherInfo(
        temperature: 66,
        condition: WeatherCondition.rainy,
      ),
      const WeatherInfo(
        temperature: 64,
        condition: WeatherCondition.thunderstorms,
      ),
    ];

    late WeatherCubit weatherCubit;

    setUp(() {
      weatherCubit = _MockWeatherCubit();
    });

    for (final info in weatherInfo) {
      testWidgets('renders a ${info.condition} weather card', (tester) async {
        when(() => weatherCubit.state).thenReturn(info);
        await tester.pumpApp(
          BlocProvider.value(
            value: weatherCubit,
            child: const WeatherCardView(),
          ),
        );

        expect(find.text('${info.temperature}°'), findsOneWidget);
        expect(find.text(info.conditionLabel(tester.l10n)), findsOneWidget);
      });
    }
  });
}
