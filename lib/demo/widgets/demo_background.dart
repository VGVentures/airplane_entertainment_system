import 'package:airplane_entertainment_system/demo/demo.dart';
import 'package:flutter/material.dart' hide Image;

class DemoBackground extends StatelessWidget {
  const DemoBackground({
    required this.page,
    super.key,
  });

  final int page;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                if (page == 1)
                  const Color(0xFFFFFFFF)
                else
                  const Color(0xffb1fff8),
                const Color(0xFF00A8DC),
              ],
              stops: [
                if (page == 1) 0.2 else 0.0,
                1.0,
              ],
              begin: Alignment.topRight,
              end: Alignment.centerLeft,
            ),
          ),
        ),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 600),
          opacity: page == 0 ? 1 : 0,
          child: const Clouds(
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
