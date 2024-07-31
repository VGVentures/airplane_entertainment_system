import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_repository/weather_repository.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc({
    required WeatherRepository weatherRepository,
  })  : _weatherRepository = weatherRepository,
        super(const WeatherState()) {
    on<WeatherUpdatesRequested>(_onWeatherUpdatesRequested);
  }

  final WeatherRepository _weatherRepository;

  Future<void> _onWeatherUpdatesRequested(
    WeatherUpdatesRequested event,
    Emitter<WeatherState> emit,
  ) async {
    await emit.forEach(
      _weatherRepository.weatherInformation,
      onData: (weatherInfo) {
        return state.copyWith(
          weatherInfo: weatherInfo,
          status: WeatherStatus.updating,
        );
      },
      onError: (error, stackTrace) {
        return state.copyWith(status: WeatherStatus.error);
      },
    );
  }
}
