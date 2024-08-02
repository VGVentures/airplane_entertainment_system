import 'package:aes_ui/aes_ui.dart';
import 'package:airplane_entertainment_system/airplane_entertainment_system/airplane_entertainment_system.dart';
import 'package:airplane_entertainment_system/music_player/music_player.dart';
import 'package:airplane_entertainment_system/overview/overview.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_repository/music_repository.dart';
import 'package:weather_repository/weather_repository.dart';

import '../../helpers/helpers.dart';

class _MockAudioCache extends Mock implements AudioCache {}

void main() {
  group('$AirplaneEntertainmentSystemScreen', () {
    late WeatherRepository weatherRepository;
    late MusicRepository musicRepository;
    late AudioPlayer audioPlayer;

    setUp(() {
      weatherRepository = MockWeatherRepository();
      when(() => weatherRepository.weatherInformation)
          .thenAnswer((_) => const Stream.empty());

      musicRepository = MockMusicRepository();
      when(musicRepository.getTracks).thenReturn(const []);

      audioPlayer = MockAudioPlayer();
      when(() => audioPlayer.onPositionChanged)
          .thenAnswer((_) => const Stream.empty());
      when(() => audioPlayer.onPlayerStateChanged)
          .thenAnswer((_) => const Stream.empty());
      when(audioPlayer.release).thenAnswer((_) async {});

      final audioCache = _MockAudioCache();
      when(() => audioPlayer.audioCache).thenReturn(audioCache);
    });

    testWidgets('shows $AesNavigationRail on large screens', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1600, 1200));
      await tester.pumpApp(
        const AirplaneEntertainmentSystemScreen(),
        layout: AesLayoutData.large,
        weatherRepository: weatherRepository,
      );

      expect(find.byType(AesNavigationRail), findsOneWidget);
    });

    testWidgets('shows $AesBottomNavigationBar on small screens',
        (tester) async {
      await tester.pumpApp(
        const AirplaneEntertainmentSystemScreen(),
        layout: AesLayoutData.small,
        weatherRepository: weatherRepository,
      );

      expect(find.byType(AesBottomNavigationBar), findsOneWidget);
    });

    testWidgets('shows TopButtonBar', (tester) async {
      await tester.pumpApp(
        const AirplaneEntertainmentSystemScreen(),
        layout: AesLayoutData.small,
        weatherRepository: weatherRepository,
      );

      expect(find.byType(TopButtonBar), findsOneWidget);
    });

    testWidgets('contains background', (tester) async {
      await tester.pumpApp(
        const AirplaneEntertainmentSystemScreen(),
        layout: AesLayoutData.small,
        weatherRepository: weatherRepository,
      );

      expect(find.byType(SystemBackground), findsOneWidget);
    });

    testWidgets('shows OverviewPage initially', (tester) async {
      await tester.pumpApp(
        const AirplaneEntertainmentSystemScreen(),
        layout: AesLayoutData.small,
        weatherRepository: weatherRepository,
      );

      expect(find.byType(OverviewPage), findsOneWidget);
    });

    testWidgets('shows MusicPlayerPage when icon is selected', (tester) async {
      await tester.pumpApp(
        const AirplaneEntertainmentSystemScreen(),
        layout: AesLayoutData.small,
        weatherRepository: weatherRepository,
        musicRepository: musicRepository,
        audioPlayer: audioPlayer,
      );

      await tester.tap(find.byIcon(Icons.music_note));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 650));

      expect(find.byType(MusicPlayerPage), findsOneWidget);
    });

    for (final layout in AesLayoutData.values) {
      testWidgets(
          'shows $OverviewPage when icon is '
          'selected for $layout layout', (tester) async {
        await tester.pumpApp(
          const AirplaneEntertainmentSystemScreen(),
          layout: layout,
          weatherRepository: weatherRepository,
          musicRepository: musicRepository,
          audioPlayer: audioPlayer,
        );

        await tester.tap(find.byIcon(Icons.music_note));
        await tester.pump(const Duration(milliseconds: 600));

        await tester.tap(find.byIcon(Icons.airplanemode_active_outlined));
        await tester.pump(const Duration(milliseconds: 600));

        expect(find.byType(OverviewPage), findsOneWidget);
      });
    }
  });
}
