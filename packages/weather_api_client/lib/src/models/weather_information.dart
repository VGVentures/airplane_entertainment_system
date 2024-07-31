import 'package:equatable/equatable.dart';

/// Describes the weather in a single word.
enum WeatherCondition {
  /// Sunny weather, no clouds.
  clear,

  /// Sky covered with clouds.
  cloudy,

  /// Cloudy with also rain falling.
  rainy,

  /// Thunderstorms with rain and lightning.
  thunderstorms,
}

/// {@template weather_information}
/// Contains the temperature and condition of the weather.
/// {@endtemplate}
class WeatherInformation extends Equatable {
  /// {@macro weather_information}
  const WeatherInformation({
    required this.temperature,
    required this.condition,
  });

  /// The temperature in degrees Fahrenheit.
  final int temperature;

  /// The condition that describes the weather.
  final WeatherCondition condition;

  @override
  List<Object> get props => [temperature, condition];
}
