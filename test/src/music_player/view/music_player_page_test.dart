import 'package:airplane_entertainment_system/music_player/view/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_experience.dart';

void main() {
  group('MusicPlayerPage', () {
    testWidgets('contains MusicPlayerPage', (tester) async {
      await tester.pumpExperience(
        const Scaffold(
          body: MusicPlayerPage(),
        ),
      );

      expect(find.byType(MusicMenuView), findsOneWidget);
      expect(find.byType(MusicPlayerView), findsOneWidget);
    });

    testWidgets('contains back button', (tester) async {
      await tester.pumpExperience(
        const Scaffold(
          body: MusicPlayerPage(),
        ),
      );

      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    });

    testWidgets('contains slider and changing it does nothing', (tester) async {
      await tester.pumpExperience(
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
