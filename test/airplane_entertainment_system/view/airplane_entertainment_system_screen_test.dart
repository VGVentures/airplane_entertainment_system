import 'package:aes_ui/aes_ui.dart';
import 'package:airplane_entertainment_system/airplane_entertainment_system/airplane_entertainment_system.dart';
import 'package:airplane_entertainment_system/music_player/music_player.dart';
import 'package:airplane_entertainment_system/overview/overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_repository/music_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('$AirplaneEntertainmentSystemScreen', () {
    late MusicRepository musicRepository;
    late AudioPlayer audioPlayer;

    setUp(() {
      musicRepository = MockMusicRepository();
      when(musicRepository.getTracks).thenReturn(const []);

      audioPlayer = MockAudioPlayer();
      when(() => audioPlayer.audioSource).thenReturn(HlsAudioSource(Uri()));
      when(() => audioPlayer.positionStream)
          .thenAnswer((_) => const Stream.empty());
      when(() => audioPlayer.playingStream)
          .thenAnswer((_) => const Stream.empty());
      when(() => audioPlayer.currentIndexStream)
          .thenAnswer((_) => const Stream.empty());
    });

    testWidgets('shows $AesNavigationRail on large screens', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1600, 1200));
      await tester.pumpApp(
        const AirplaneEntertainmentSystemScreen(),
        layout: AesLayoutData.large,
      );

      expect(find.byType(AesNavigationRail), findsOneWidget);
    });

    testWidgets('shows $AesBottomNavigationBar on small screens',
        (tester) async {
      await tester.pumpApp(
        const AirplaneEntertainmentSystemScreen(),
        layout: AesLayoutData.small,
      );

      expect(find.byType(AesBottomNavigationBar), findsOneWidget);
    });

    testWidgets('shows TopButtonBar', (tester) async {
      await tester.pumpApp(
        const AirplaneEntertainmentSystemScreen(),
        layout: AesLayoutData.small,
      );

      expect(find.byType(TopButtonBar), findsOneWidget);
    });

    testWidgets('contains background', (tester) async {
      await tester.pumpApp(
        const AirplaneEntertainmentSystemScreen(),
        layout: AesLayoutData.small,
      );

      expect(find.byType(SystemBackground), findsOneWidget);
    });

    testWidgets('shows OverviewPage initially', (tester) async {
      await tester.pumpApp(
        const AirplaneEntertainmentSystemScreen(),
        layout: AesLayoutData.small,
      );

      expect(find.byType(OverviewPage), findsOneWidget);
    });

    testWidgets('shows MusicPlayerPage when icon is selected', (tester) async {
      await tester.pumpApp(
        const AirplaneEntertainmentSystemScreen(),
        layout: AesLayoutData.small,
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
