import 'package:aes_ui/aes_ui.dart';
import 'package:airplane_entertainment_system/airplane_entertainment_system/airplane_entertainment_system.dart';
import 'package:airplane_entertainment_system/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_repository/music_repository.dart';
import 'package:weather_repository/weather_repository.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => WeatherRepository(),
        ),
        RepositoryProvider(
          create: (context) => MusicRepository(),
        ),
        RepositoryProvider(
          create: (context) => AudioPlayer(),
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
