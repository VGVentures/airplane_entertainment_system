import 'package:airplane_entertainment_system/overview/widgets/weather_card.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_repository/weather_repository.dart';

import '../../helpers/pump_experience.dart';
import '../../helpers/tester_l10n.dart';

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

    for (final info in weatherInfo) {
      testWidgets('renders a ${info.condition} weather card', (tester) async {
        await tester.pumpApp(
          WeatherCard(info: info),
        );

        expect(find.text('${info.temperature}°'), findsOneWidget);
        expect(find.text(info.conditionLabel(tester.l10n)), findsOneWidget);
      });
    }
  });
}
