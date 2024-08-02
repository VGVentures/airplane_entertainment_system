// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

import 'package:airplane_entertainment_system/airplane_entertainment_system/airplane_entertainment_system.dart';
import 'package:airplane_entertainment_system/music_player/music_player.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockMusicPlayerCubit extends MockCubit<MusicPlayerState>
    implements MusicPlayerCubit {}

void main() {
  group('$MuteButton', () {
    testWidgets('finds one MuteButton Widget', (tester) async {
      final MusicPlayerCubit cubit = _MockMusicPlayerCubit();
      when(() => cubit.state).thenReturn(const MusicPlayerState());

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider.value(
              value: cubit,
              child: MuteButton(),
            ),
          ),
        ),
      );

      expect(find.byType(MuteButton), findsOneWidget);
    });

    testWidgets('toggles mute when pressed', (tester) async {
      final MusicPlayerCubit cubit = _MockMusicPlayerCubit();

      whenListen(
        cubit,
        Stream.fromIterable(
          [
            const MusicPlayerState(mute: true),
          ],
        ),
        initialState: const MusicPlayerState(mute: false),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlocProvider.value(
              value: cubit,
              child: MuteButton(),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(IconButton));
      verify(cubit.toggleMute).called(1);

      await tester.pump();
      expect(find.byIcon(Icons.volume_off), findsOneWidget);
    });
  });
}
