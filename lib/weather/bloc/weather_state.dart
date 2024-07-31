part of 'weather_bloc.dart';

enum WeatherStatus { initial, updating, error }

class WeatherState extends Equatable {
  const WeatherState({
    this.weatherInfo,
    this.status = WeatherStatus.initial,
  });

  final WeatherInformation? weatherInfo;
  final WeatherStatus status;

  WeatherState copyWith({
    WeatherInformation? weatherInfo,
    WeatherStatus? status,
  }) {
    return WeatherState(
      weatherInfo: weatherInfo ?? this.weatherInfo,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [weatherInfo, status];
}
