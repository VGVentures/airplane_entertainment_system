import 'package:aes_ui/aes_ui.dart';
import 'package:airplane_entertainment_system/l10n/l10n.dart';
import 'package:airplane_entertainment_system/overview/overview.dart';
import 'package:flutter/material.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final layout = AesLayout.of(context);

    return switch (layout) {
      AesLayoutData.small => const _SmallOverviewPage(),
      AesLayoutData.large => const _LargeOverviewPage(),
    };
  }
}

class _SmallOverviewPage extends StatelessWidget {
  const _SmallOverviewPage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
    );
  }
}

class _LargeOverviewPage extends StatelessWidget {
  const _LargeOverviewPage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: Row(
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
          maxLines: 2,
          style: AesTextStyles.headlineLarge,
          overflow: TextOverflow.ellipsis,
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
