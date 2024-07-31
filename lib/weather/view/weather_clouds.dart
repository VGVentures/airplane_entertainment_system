import 'package:airplane_entertainment_system/weather/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_repository/weather_repository.dart';

class WeatherClouds extends StatelessWidget {
  const WeatherClouds({
    required this.count,
    required this.averageScale,
    required this.averageVelocity,
    super.key,
  });

  final int count;
  final double averageScale;
  final double averageVelocity;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        return Clouds(
          count: count,
          averageScale: averageScale,
          averageVelocity: averageVelocity,
          style: state.status == WeatherStatus.updating
              ? switch (state.weatherInfo!.condition) {
                  WeatherCondition.clear => CloudStyle.none,
                  WeatherCondition.cloudy => CloudStyle.light,
                  WeatherCondition.rainy => CloudStyle.medium,
                  WeatherCondition.thunderstorms => CloudStyle.dark,
                }
              : CloudStyle.light,
        );
      },
    );
  }
}
