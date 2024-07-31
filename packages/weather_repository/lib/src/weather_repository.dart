import 'dart:math';

import 'package:meta/meta.dart';
import 'package:weather_repository/weather_repository.dart';

/// {@template weather_repository}
/// Provides (fake) real time information of the weather.
/// {@endtemplate}
class WeatherRepository {
  /// {@macro weather_repository}
  WeatherRepository({
    @visibleForTesting Random? random,
  }) : _random = random ?? Random();

  late WeatherInfo _weather = nextWeatherInfo();
  final Random _random;

  /// The current weather information.
  WeatherInfo get weather => _weather;

  /// Stream of weather updates.
  Stream<WeatherInfo> get weatherStream async* {
    while (true) {
      await Future<void>.delayed(_interval);
      final info = nextWeatherInfo(_weather);
      _weather = info;
      yield info;
    }
  }

  /// Random interval between 60 and 75 seconds.
  Duration get _interval {
    final seconds = _random.nextInt(15) + 60;
    return Duration(seconds: seconds);
  }

  /// Returns the next [WeatherInfo] based on the previous one.
  ///
  /// The next [WeatherInfo] will be adjacent to the [previous] one.
  /// If [previous] is `null`, a random [WeatherInfo] is returned.
  @visibleForTesting
  WeatherInfo nextWeatherInfo([WeatherInfo? previous]) {
    if (previous == null) {
      final random = _random.nextInt(weatherInfos.length);
      return weatherInfos[random];
    }

    final index = weatherInfos.indexOf(previous);
    if (index == 0) {
      return weatherInfos[1];
    } else if (index == weatherInfos.length - 1) {
      return weatherInfos[weatherInfos.length - 2];
    } else {
      final values = [index - 1, index + 1];
      final random = _random.nextInt(values.length);
      final nextIndex = values[random];
      return weatherInfos[nextIndex];
    }
  }
}

/// List of [WeatherInfo] used to generate the next weather.
@visibleForTesting
const weatherInfos = [
  WeatherInfo(
    temperature: 77,
    condition: WeatherCondition.clear,
  ),
  WeatherInfo(
    temperature: 71,
    condition: WeatherCondition.cloudy,
  ),
  WeatherInfo(
    temperature: 66,
    condition: WeatherCondition.rainy,
  ),
  WeatherInfo(
    temperature: 62,
    condition: WeatherCondition.thunderstorms,
  ),
];
