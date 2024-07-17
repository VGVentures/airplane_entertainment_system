import 'package:airplane_entertainment_system/demo/demo.dart';
import 'package:airplane_entertainment_system/music_player/music_player.dart';
import 'package:airplane_entertainment_system/overview/overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('AirplaneEntertainmentSystemDemo', () {
    testWidgets('shows LeftSideNavigationRail', (tester) async {
      await tester.pumpExperience(const AirplaneEntertainmentSystemDemo());

      expect(find.byType(LeftSideNavigationRail), findsOneWidget);
    });
    testWidgets('shows TopButtonBar', (tester) async {
      await tester.pumpExperience(const AirplaneEntertainmentSystemDemo());

      expect(find.byType(TopButtonBar), findsOneWidget);
    });

    testWidgets('contains background', (tester) async {
      await tester.pumpExperience(const AirplaneEntertainmentSystemDemo());

      expect(find.byType(DemoBackground), findsOneWidget);
    });

    testWidgets('shows OverviewPage initially', (tester) async {
      await tester.pumpExperience(const AirplaneEntertainmentSystemDemo());

      expect(find.byType(OverviewPage), findsOneWidget);
    });

    testWidgets('shows MusicPlayerPage when icon is selected', (tester) async {
      await tester.pumpExperience(const AirplaneEntertainmentSystemDemo());

      await tester.tap(find.byIcon(Icons.headphones));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 650));

      expect(find.byType(MusicPlayerPage), findsOneWidget);
    });

    testWidgets('shows OverviewPage when icon is selected', (tester) async {
      await tester.pumpExperience(const AirplaneEntertainmentSystemDemo());

      await tester.tap(find.byIcon(Icons.headphones));
      await tester.pump(const Duration(milliseconds: 600));

      await tester.tap(find.byIcon(Icons.airplanemode_active));
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.byType(OverviewPage), findsOneWidget);
    });
  });
}
