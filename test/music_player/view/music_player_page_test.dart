import 'package:aes_ui/aes_ui.dart';
import 'package:airplane_entertainment_system/music_player/cubit/music_player_cubit.dart';
import 'package:airplane_entertainment_system/music_player/view/view.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_repository/music_repository.dart';

import '../../helpers/pump_experience.dart';

class _MockMusicPlayerCubit extends MockCubit<MusicPlayerState>
    implements MusicPlayerCubit {}

void main() {
  const tracks = [
    MusicTrack(index: 0, title: 'Title0', artist: 'Artist0', path: 'path0'),
    MusicTrack(index: 1, title: 'Title1', artist: 'Artist1', path: 'path1'),
  ];

  group('MusicPlayerPage', () {
    late MusicPlayerCubit cubit;

    setUp(() {
      cubit = _MockMusicPlayerCubit();
      when(() => cubit.state).thenReturn(
        const MusicPlayerState(tracks: tracks, currentTrackIndex: 0),
      );
    });

    testWidgets('contains MusicPlayerView', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: BlocProvider.value(
            value: cubit,
            child: const MusicPlayerPage(),
          ),
        ),
      );

      expect(find.byType(MusicMenuView), findsOneWidget);
      expect(find.byType(MusicPlayerView), findsOneWidget);
    });

    testWidgets('when screen size is small, player is shown in a bottom sheet',
        (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: BlocProvider.value(
            value: cubit,
            child: const MusicPlayerPage(),
          ),
        ),
        layout: AesLayoutData.small,
      );

      final playerFinder = find.byType(MusicPlayerView);
      expect(playerFinder, findsNothing);

      final buttonFinder = find.byType(MusicFloatingButton);
      expect(buttonFinder, findsOneWidget);

      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      expect(playerFinder, findsOneWidget);
    });
  });

  group('MusicPlayerView', () {
    late MusicPlayerCubit cubit;

    setUp(() {
      cubit = _MockMusicPlayerCubit();
      when(() => cubit.state).thenReturn(
        const MusicPlayerState(tracks: tracks),
      );
    });

    Widget subject() {
      return BlocProvider<MusicPlayerCubit>.value(
        value: cubit,
        child: const Material(
          child: MusicPlayerView(),
        ),
      );
    }

    testWidgets(
      'calls [MusicPlayerCubit.previous] when previous track button is pressed',
      (tester) async {
        await tester.pumpApp(subject());

        await tester.tap(find.byIcon(Icons.first_page_rounded));
        verify(cubit.previous).called(1);
      },
    );

    testWidgets(
      'calls [MusicPlayerCubit.next] when next track button is pressed',
      (tester) async {
        await tester.pumpApp(subject());

        await tester.tap(find.byIcon(Icons.last_page_rounded));
        verify(cubit.next).called(1);
      },
    );

    testWidgets(
      'calls [MusicPlayerCubit.togglePlayPause] when play button is pressed',
      (tester) async {
        await tester.pumpApp(subject());

        await tester.tap(find.byIcon(Icons.play_arrow));
        verify(cubit.togglePlayPause).called(1);
      },
    );

    testWidgets(
      'calls [MusicPlayerCubit.seek] when slider is moved',
      (tester) async {
        await tester.pumpApp(subject());

        await tester.drag(find.byType(Slider), const Offset(10, 0));
        verify(() => cubit.seek(any())).called(greaterThan(0));
      },
    );

    testWidgets(
      'calls [MusicPlayerCubit.toggleLoop] when repeat button is pressed',
      (tester) async {
        await tester.pumpApp(subject());

        await tester.tap(find.byIcon(Icons.repeat_rounded));
        verify(cubit.toggleLoop).called(1);
      },
    );

    testWidgets(
      'calls [MusicPlayerCubit.toggleShuffle] when shuffle button is pressed',
      (tester) async {
        await tester.pumpApp(subject());

        await tester.tap(find.byIcon(Icons.shuffle));
        verify(cubit.toggleShuffle).called(1);
      },
    );
  });

  group('MusicMenuView', () {
    late MusicPlayerCubit cubit;

    setUp(() {
      cubit = _MockMusicPlayerCubit();
      when(() => cubit.state).thenReturn(
        const MusicPlayerState(tracks: tracks),
      );
    });

    Widget subject() {
      return BlocProvider<MusicPlayerCubit>.value(
        value: cubit,
        child: const Material(child: MusicMenuView()),
      );
    }

    testWidgets(
      'calls [MusicPlayerCubit.playTrack] when track is selected',
      (tester) async {
        await tester.pumpApp(subject());

        await tester.tap(find.text('Title0'));
        verify(() => cubit.playTrack(tracks[0])).called(1);
      },
    );
  });
}
