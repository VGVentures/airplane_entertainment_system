import 'package:airplane_entertainment_system/weather/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_repository/weather_repository.dart';

/// {@template weather_background}
/// A widget that displays a background that changes based on the weather
/// condition.
/// {@endtemplate}
class WeatherBackground extends StatelessWidget {
  /// {@macro weather_background}
  const WeatherBackground({required this.enabled, super.key});

  /// Whether to update the background colors based on the weather condition.
  ///
  /// If `false`, the background will always be the default gradient.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        final defaultColors = [
          const Color(0xFFFFFFFF),
          const Color(0xFF00A8DC),
        ];
        final colors = switch (state.weatherInfo?.condition) {
          WeatherCondition.rainy => [
              const Color(0xFFC3EFEC),
              const Color(0xFF3287A1),
            ],
          WeatherCondition.thunderstorms => [
              const Color(0xFFB7CAC8),
              const Color(0xFF7D909A),
            ],
          _ => [
              const Color(0xffb1fff8),
              const Color(0xFF00A8DC),
            ]
        };

        return AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: enabled ? colors : defaultColors,
              stops: const [0.0, 1.0],
              begin: Alignment.topRight,
              end: Alignment.centerLeft,
            ),
          ),
        );
      },
    );
  }
}
