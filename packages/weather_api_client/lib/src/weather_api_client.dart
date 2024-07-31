import 'dart:async';
import 'dart:math';

import 'package:meta/meta.dart';
import 'package:weather_api_client/src/models/weather_information.dart';
import 'package:weather_api_client/weather_api_client.dart';

/// {@template weather_api_client}
/// The weather API client.
///
/// This is a mock API client that simulates fetching weather information from a
/// server. The stream emits a new [WeatherInformation] object every 60 to 90
/// seconds with fake information of current weather.
/// {@endtemplate}
class WeatherApiClient {
  /// {@macro weather_api_client}
  WeatherApiClient({
    Random? random,
  }) : _random = random ?? Random();

  final Random _random;

  final StreamController<WeatherInformation> _controller =
      StreamController<WeatherInformation>();

  static const _updateInterval = Duration(seconds: 3);

  Timer? _timer;

  /// The last weather information that was generated.
  @visibleForTesting
  WeatherInformation? lastWeatherInformation;

  /// Random interval between up to 30 seconds.
  Duration get _randomInterval {
    final seconds = _random.nextInt(1);
    return Duration(seconds: seconds);
  }

  /// Retrieves the weather information.
  ///
  /// Weather information is added to the stream when called and every 60 to 90
  /// seconds after that until the client is disposed. If this were a real API
  /// client, the data would be fetched from a server.
  Stream<WeatherInformation> get weatherInformation {
    _controller.add(nextWeatherInformation());

    _timer ??= Timer.periodic(_updateInterval, (timer) {
      Future<void>.delayed(_randomInterval).then(
        (_) => _controller.add(nextWeatherInformation()),
      );
    });

    return _controller.stream;
  }

  /// Returns the next [WeatherInformation] based on the last generated one.
  ///
  /// The next [WeatherInformation] will be adjacent to the previous one.
  /// If [lastWeatherInformation] is `null`, a random [WeatherInformation]
  /// is returned.
  @visibleForTesting
  WeatherInformation nextWeatherInformation() {
    WeatherInformation information;
    if (lastWeatherInformation == null) {
      final random = _random.nextInt(weatherInfos.length);
      information = weatherInfos[random];
    } else {
      final index = weatherInfos.indexOf(lastWeatherInformation!);
      if (index == 0) {
        information = weatherInfos[1];
      } else if (index == weatherInfos.length - 1) {
        information = weatherInfos[weatherInfos.length - 2];
      } else {
        final values = [index - 1, index + 1];
        final random = _random.nextInt(values.length);
        final nextIndex = values[random];
        information = weatherInfos[nextIndex];
      }
    }
    lastWeatherInformation = information;
    return information;
  }

  /// Cancels the timer and closes the stream controller.
  Future<void> dispose() async {
    _timer?.cancel();
    await _controller.close();
  }
}

/// List of [WeatherInformation] used to generate the next weather.
@visibleForTesting
const weatherInfos = [
  WeatherInformation(
    temperature: 77,
    condition: WeatherCondition.clear,
  ),
  WeatherInformation(
    temperature: 71,
    condition: WeatherCondition.cloudy,
  ),
  WeatherInformation(
    temperature: 66,
    condition: WeatherCondition.rainy,
  ),
  WeatherInformation(
    temperature: 62,
    condition: WeatherCondition.thunderstorms,
  ),
];
