import 'package:airplane_entertainment_system/l10n/l10n.dart';
import 'package:airplane_entertainment_system/overview/overview.dart';
import 'package:flutter/material.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.only(left: 80),
                  child: AirplaneImage(),
                ),
              ),
              const SizedBox(width: 60),
              Expanded(
                flex: 4,
                child: ListView(
                  padding: const EdgeInsets.only(right: 80),
                  children: const [
                    WelcomeCopy(),
                    SizedBox(height: 40),
                    FlightTrackingCard(),
                    SizedBox(height: 20),
                    WeatherCard(),
                    SizedBox(height: 20),
                    MusicCard(),
                    SizedBox(height: 20),
                    MovieCard(),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 75,
            bottom: 50,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.video_camera_back_outlined,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class WelcomeCopy extends StatelessWidget {
  const WelcomeCopy({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 50),
        Text(
          l10n.welcomeMessage,
          style: const TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.w600,
            height: 1,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          l10n.welcomeSubtitle,
          style: TextStyle(
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }
}
