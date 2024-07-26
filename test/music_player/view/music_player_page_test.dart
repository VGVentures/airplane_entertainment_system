import 'package:aes_ui/aes_ui.dart';
import 'package:airplane_entertainment_system/music_player/view/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_experience.dart';

void main() {
  group('MusicPlayerPage', () {
    testWidgets('contains MusicPlayerPage', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: MusicPlayerPage(),
        ),
      );

      expect(find.byType(MusicMenuView), findsOneWidget);
      expect(find.byType(MusicPlayerView), findsOneWidget);
    });

    testWidgets('when screen size is small, player is shown in a bottom sheet',
        (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: MusicPlayerPage(),
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

    testWidgets('contains slider and changing it does nothing', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: MusicPlayerPage(),
        ),
      );

      expect(find.byType(Slider), findsOneWidget);
      final slider = tester.widget<Slider>(find.byType(Slider));
      slider.onChanged!(0);
    });
  });
}
