import 'package:airplane_entertainment_system/generated/assets.gen.dart';
import 'package:airplane_entertainment_system/l10n/l10n.dart';
import 'package:airplane_entertainment_system/weather/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_repository/weather_repository.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherCubit(
        weatherRepository: context.read(),
      )..initialize(),
      child: const WeatherCardView(),
    );
  }
}

class WeatherCardView extends StatelessWidget {
  const WeatherCardView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final info = context.select((WeatherCubit cubit) => cubit.state);
    final temperature = '${info?.temperature ?? '--'}°';
    final label = info?.conditionLabel(l10n) ?? '';
    final gradient = info?.gradient ?? _clearWeatherGradient;
    final imageAsset = info?.imageAsset;

    return SizedBox(
      height: 200,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: _WeatherDetails(
                temperature: temperature,
                label: label,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 148,
              height: 200,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: _WeatherIllustration(
                  key: ValueKey(info?.condition),
                  gradient: gradient,
                  imageAsset: imageAsset,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherDetails extends StatelessWidget {
  const _WeatherDetails({
    required this.temperature,
    required this.label,
  });

  final String temperature;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          temperature,
          style: const TextStyle(
            fontSize: 80,
            height: 0.8,
          ),
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,
          ),
        ),
      ],
    );
  }
}

class _WeatherIllustration extends StatelessWidget {
  const _WeatherIllustration({
    required this.gradient,
    this.imageAsset,
    super.key,
  });

  final AssetGenImage? imageAsset;
  final List<Color> gradient;

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: UniqueKey(),
      alignment: Alignment.centerRight,
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          right: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
            ),
          ),
        ),
        if (imageAsset != null)
          Positioned(
            left: 10,
            right: 10,
            child: imageAsset!.image(
              width: 140,
              fit: BoxFit.contain,
            ),
          ),
      ],
    );
  }
}

const _clearWeatherGradient = [
  Color.fromARGB(255, 17, 204, 251),
  Color.fromARGB(255, 151, 210, 255),
];

const _cloudyWeatherGradient = [
  Color.fromARGB(255, 48, 137, 209),
  Color.fromARGB(255, 152, 201, 239),
];

const _rainyWeatherGradient = [
  Color.fromARGB(255, 92, 134, 169),
  Color.fromARGB(255, 170, 205, 233),
];

const _thunderstormsWeatherGradient = [
  Color.fromARGB(255, 53, 76, 95),
  Color.fromARGB(255, 179, 193, 203),
];

@visibleForTesting
extension WeatherUI on WeatherInfo {
  String conditionLabel(AppLocalizations l10n) {
    return switch (condition) {
      WeatherCondition.clear => l10n.clear,
      WeatherCondition.cloudy => l10n.cloudy,
      WeatherCondition.rainy => l10n.rainy,
      WeatherCondition.thunderstorms => l10n.thunderstorms,
    };
  }

  AssetGenImage get imageAsset {
    return switch (condition) {
      WeatherCondition.clear => Assets.weather.clear,
      WeatherCondition.cloudy => Assets.weather.cloudy,
      WeatherCondition.rainy => Assets.weather.rainy,
      WeatherCondition.thunderstorms => Assets.weather.thunderstorms,
    };
  }

  List<Color> get gradient {
    return switch (condition) {
      WeatherCondition.clear => _clearWeatherGradient,
      WeatherCondition.cloudy => _cloudyWeatherGradient,
      WeatherCondition.rainy => _rainyWeatherGradient,
      WeatherCondition.thunderstorms => _thunderstormsWeatherGradient,
    };
  }
}
