import 'dart:ui';

import 'package:airplane_entertainment_system/l10n/l10n.dart';
import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SizedBox(
      height: 200,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    '62°',
                    style: TextStyle(
                      fontSize: 80,
                      height: 0.8,
                    ),
                    textHeightBehavior: TextHeightBehavior(
                      applyHeightToFirstAscent: false,
                    ),
                  ),
                  Text(
                    l10n.thunderstorms,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textHeightBehavior: const TextHeightBehavior(
                      applyHeightToFirstAscent: false,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 168,
              height: 200,
              child: Stack(
                alignment: Alignment.centerRight,
                fit: StackFit.expand,
                clipBehavior: Clip.none,
                children: [
                  const Positioned(
                    left: 20,
                    top: 0,
                    bottom: 0,
                    right: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff0a6cba),
                              Color(0xff6ab9f7),
                            ],
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    left: 0,
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
                      child: Image.asset(
                        'assets/thunder.png',
                        width: 140,
                        color: const Color(0x55003366),
                        colorBlendMode: BlendMode.srcIn,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    left: 0,
                    child: Image.asset(
                      'assets/thunder.png',
                      width: 140,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
