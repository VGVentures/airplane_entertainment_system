import 'package:rxdart/subjects.dart';
import 'package:weather_api_client/weather_api_client.dart';

/// {@template weather_repository}
/// A repository for the weather information.
/// {@endtemplate}
class WeatherRepository {
  /// {@macro weather_repository}
  WeatherRepository(this._weatherApiClient);

  final WeatherApiClient _weatherApiClient;

  BehaviorSubject<WeatherInformation>? _weatherController;

  /// Stream of weather updates.
  Stream<WeatherInformation> get weatherInformation {
    if (_weatherController == null) {
      _weatherController = BehaviorSubject();

      _weatherApiClient.weatherInformation.listen((weatherInformation) {
        _weatherController!.add(weatherInformation);
      });
    }

    return _weatherController!.stream;
  }
}
