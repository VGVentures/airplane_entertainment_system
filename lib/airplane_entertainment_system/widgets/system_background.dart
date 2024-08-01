import 'package:airplane_entertainment_system/weather/weather.dart';
import 'package:flutter/material.dart' hide Image;

class SystemBackground extends StatelessWidget {
  const SystemBackground({
    required this.page,
    super.key,
  });

  final int page;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        WeatherBackground(enabled: page == 0),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 600),
          opacity: page == 0 ? 1 : 0,
          child: const WeatherClouds(
            key: Key('backgroundClouds'),
            count: 5,
            averageScale: 1,
            averageVelocity: 0.8,
          ),
        ),
      ],
    );
  }
}
