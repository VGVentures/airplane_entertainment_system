import 'package:aes_ui/aes_ui.dart';
import 'package:airplane_entertainment_system/flight_tracking/flight_tracking.dart';
import 'package:airplane_entertainment_system/l10n/l10n.dart';
import 'package:airplane_entertainment_system/overview/overview.dart';
import 'package:airplane_entertainment_system/weather/weather.dart';
import 'package:flutter/material.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final layout = AesLayout.of(context);

    return switch (layout) {
      AesLayoutData.small => const _SmallOverviewPage(),
      AesLayoutData.medium || AesLayoutData.large => const _LargeOverviewPage(),
    };
  }
}

class _SmallOverviewPage extends StatelessWidget {
  const _SmallOverviewPage();

  @override
  Widget build(BuildContext context) {
    return const DashBoard(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
    );
  }
}

class _LargeOverviewPage extends StatelessWidget {
  const _LargeOverviewPage();

  @override
  Widget build(BuildContext context) {
    final showPlane = AesLayout.of(context) == AesLayoutData.large;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showPlane)
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 80),
              child: AirplaneImage(),
            ),
          ),
        const SizedBox(width: 80),
        Expanded(
          child: DashBoard(
            padding:
                const EdgeInsets.symmetric(vertical: 20).copyWith(right: 80),
          ),
        ),
      ],
    );
  }
}

class DashBoard extends StatelessWidget {
  const DashBoard({super.key, this.padding});

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: padding,
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
        FittedBox(
          child: Text(
            l10n.welcomeMessage,
            style: AesTextStyles.headlineLarge,
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
