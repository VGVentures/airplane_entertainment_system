import 'package:aes_ui/aes_ui.dart';
import 'package:airplane_entertainment_system/airplane_entertainment_system/airplane_entertainment_system.dart';
import 'package:airplane_entertainment_system/l10n/l10n.dart';
import 'package:flight_information_repository/flight_information_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_repository/music_repository.dart';

class App extends StatelessWidget {
  const App({
    required FlightInformationRepository flightInformationRepository,
    super.key,
  }) : _flightInformationRepository = flightInformationRepository;

  final FlightInformationRepository _flightInformationRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => MusicRepository(),
        ),
        RepositoryProvider(
          create: (context) => AudioPlayer(),
        ),
        RepositoryProvider.value(
          value: _flightInformationRepository,
        ),
      ],
      child: AesLayout(
        child: MaterialApp(
          theme: const AesTheme().themeData,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AirplaneEntertainmentSystemScreen(),
        ),
      ),
    );
  }
}
