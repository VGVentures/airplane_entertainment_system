import 'package:aes_ui/aes_ui.dart';
import 'package:airplane_entertainment_system/l10n/l10n.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flight_information_repository/flight_information_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_repository/music_repository.dart';
import 'package:weather_repository/weather_repository.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

class MockMusicRepository extends Mock implements MusicRepository {}

class MockAudioPlayer extends Mock implements AudioPlayer {}

class _MockGoRouter extends Mock implements GoRouter {}

class _MockFlightRepository extends Mock
    implements FlightInformationRepository {
  @override
  Stream<FlightInformation> get flightInformation => const Stream.empty();
}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    AesLayoutData? layout,
    WeatherRepository? weatherRepository,
    MusicRepository? musicRepository,
    AudioPlayer? audioPlayer,
    FlightInformationRepository? flightInformationRepository,
  }) async {
    if (layout == AesLayoutData.large) {
      await binding.setSurfaceSize(const Size(1600, 1200));
      addTearDown(() => binding.setSurfaceSize(null));
    }

    return pumpWidget(
      AesLayout(
        data: layout,
        child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider<WeatherRepository>(
              create: (context) => weatherRepository ?? MockWeatherRepository(),
            ),
            RepositoryProvider<MusicRepository>(
              create: (context) => musicRepository ?? MockMusicRepository(),
            ),
            RepositoryProvider<AudioPlayer>(
              create: (context) => audioPlayer ?? MockAudioPlayer(),
            ),
            RepositoryProvider<FlightInformationRepository>(
              create: (_) =>
                  flightInformationRepository ?? _MockFlightRepository(),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: InheritedGoRouter(
              goRouter: _MockGoRouter(),
              child: widget,
            ),
          ),
        ),
      ),
    );
  }
}
