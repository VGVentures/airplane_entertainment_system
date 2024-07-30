import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:weather_repository/weather_repository.dart';

class WeatherCubit extends Cubit<WeatherInfo?> {
  WeatherCubit({
    required WeatherRepository weatherRepository,
  })  : _weatherRepository = weatherRepository,
        super(null) {
    _weatherSubscription =
        _weatherRepository.weatherStream.listen(_onWeatherInfo);
  }

  final WeatherRepository _weatherRepository;
  late final StreamSubscription<WeatherInfo> _weatherSubscription;

  void _onWeatherInfo(WeatherInfo weatherInfo) {
    emit(weatherInfo);
  }

  void initialize() {
    _onWeatherInfo(_weatherRepository.weather);
  }

  @override
  Future<void> close() {
    _weatherSubscription.cancel();
    return super.close();
  }
}
