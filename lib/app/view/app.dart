import 'package:aes_ui/aes_ui.dart';
import 'package:airplane_entertainment_system/app_router/app_router.dart';
import 'package:airplane_entertainment_system/l10n/l10n.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flight_information_repository/flight_information_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_repository/music_repository.dart';
import 'package:weather_repository/weather_repository.dart';

class App extends StatelessWidget {
  const App({
    required WeatherRepository weatherRepository,
    required MusicRepository musicRepository,
    required AudioPlayer audioPlayer,
    required FlightInformationRepository flightInformationRepository,
    required AppRouter appRouter,
    super.key,
  })  : _weatherRepository = weatherRepository,
        _musicRepository = musicRepository,
        _audioPlayer = audioPlayer,
        _flightInformationRepository = flightInformationRepository,
        _appRouter = appRouter;

  final WeatherRepository _weatherRepository;
  final MusicRepository _musicRepository;
  final AudioPlayer _audioPlayer;
  final FlightInformationRepository _flightInformationRepository;
  final AppRouter _appRouter;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: _weatherRepository,
        ),
        RepositoryProvider.value(
          value: _musicRepository,
        ),
        RepositoryProvider.value(
          value: _audioPlayer,
        ),
        RepositoryProvider.value(
          value: _flightInformationRepository,
        ),
      ],
      child: AesLayout(
        child: MaterialApp.router(
          theme: const AesTheme().themeData,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: _appRouter.routes,
        ),
      ),
    );
  }
}
