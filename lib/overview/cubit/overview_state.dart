part of 'overview_cubit.dart';

class OverviewState extends Equatable {
  const OverviewState({this.weatherInfo});

  final WeatherInfo? weatherInfo;

  @override
  List<Object?> get props => [weatherInfo];
}
