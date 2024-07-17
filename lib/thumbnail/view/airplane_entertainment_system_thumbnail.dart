import 'package:airplane_entertainment_system/demo/demo.dart';
import 'package:airplane_entertainment_system/overview/overview.dart';
import 'package:flutter/material.dart';

class AirplaneEntertainmentSystemThumbnail extends StatelessWidget {
  const AirplaneEntertainmentSystemThumbnail({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xffb1fff8),
            Color(0xFF00A8DC),
          ],
          begin: Alignment.topRight,
          end: Alignment.centerLeft,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Clouds(
            count: 2,
            averageScale: 0.4,
            averageVelocity: 1.5,
          ),
          Padding(
            padding: EdgeInsets.all(40),
            child: Center(
              child: AirplaneImage(),
            ),
          ),
          Clouds(
            count: 2,
            averageScale: 0.2,
            averageVelocity: 2,
          ),
        ],
      ),
    );
  }
}
