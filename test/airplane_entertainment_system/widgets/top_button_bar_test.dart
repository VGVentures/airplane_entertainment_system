import 'package:airplane_entertainment_system/airplane_entertainment_system/airplane_entertainment_system.dart';
import 'package:airplane_entertainment_system/music_player/music_player.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockMusicPlayerCubit extends MockCubit<MusicPlayerState>
    implements MusicPlayerCubit {}

void main() {
  group('$TopButtonBar', () {
    testWidgets('contains volume button', (tester) async {
      await tester.pumpSubject();

      expect(find.byIcon(Icons.volume_up), findsOneWidget);
      await tester.tap(find.byIcon(Icons.volume_up));
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSubject() {
    final MusicPlayerCubit musicPlayerCubit = _MockMusicPlayerCubit();
    when(() => musicPlayerCubit.state).thenReturn(const MusicPlayerState());

    return pumpApp(
      BlocProvider.value(
        value: musicPlayerCubit,
        child: const Scaffold(
          body: TopButtonBar(),
        ),
      ),
    );
  }
}
