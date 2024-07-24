import 'package:airplane_entertainment_system/airplane_entertainment_system/airplane_entertainment_system.dart';
import 'package:airplane_entertainment_system/music_player/music_player.dart';
import 'package:airplane_entertainment_system/overview/overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('AirplaneEntertainmentSystemScreen', () {
    testWidgets('shows LeftSideNavigationRail', (tester) async {
      await tester.pumpExperience(const AirplaneEntertainmentSystemScreen());

      expect(find.byType(LeftSideNavigationRail), findsOneWidget);
    });
    testWidgets('shows TopButtonBar', (tester) async {
      await tester.pumpExperience(const AirplaneEntertainmentSystemScreen());

      expect(find.byType(TopButtonBar), findsOneWidget);
    });

    testWidgets('contains background', (tester) async {
      await tester.pumpExperience(const AirplaneEntertainmentSystemScreen());

      expect(find.byType(SystemBackground), findsOneWidget);
    });

    testWidgets('shows OverviewPage initially', (tester) async {
      await tester.pumpExperience(const AirplaneEntertainmentSystemScreen());

      expect(find.byType(OverviewPage), findsOneWidget);
    });

    testWidgets('shows MusicPlayerPage when icon is selected', (tester) async {
      await tester.pumpExperience(const AirplaneEntertainmentSystemScreen());

      await tester.tap(find.byIcon(Icons.headphones));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 650));

      expect(find.byType(MusicPlayerPage), findsOneWidget);
    });

    testWidgets('shows OverviewPage when icon is selected', (tester) async {
      await tester.pumpExperience(const AirplaneEntertainmentSystemScreen());

      await tester.tap(find.byIcon(Icons.headphones));
      await tester.pump(const Duration(milliseconds: 600));

      await tester.tap(find.byIcon(Icons.airplanemode_active_outlined));
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.byType(OverviewPage), findsOneWidget);
    });
  });
}
