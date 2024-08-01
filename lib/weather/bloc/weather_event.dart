part of 'weather_bloc.dart';

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class WeatherUpdatesRequested extends WeatherEvent {
  const WeatherUpdatesRequested();
}
