import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_repository/weather_repository.dart';

part 'overview_state.dart';

class OverviewCubit extends Cubit<OverviewState> {
  OverviewCubit({
    required WeatherRepository weatherRepository,
  })  : _weatherRepository = weatherRepository,
        super(const OverviewState()) {
    _weatherSubscription =
        _weatherRepository.weatherStream.listen(_onWeatherInfo);
  }

  final WeatherRepository _weatherRepository;
  late final StreamSubscription<WeatherInfo> _weatherSubscription;

  void _onWeatherInfo(WeatherInfo weatherInfo) {
    emit(OverviewState(weatherInfo: weatherInfo));
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
