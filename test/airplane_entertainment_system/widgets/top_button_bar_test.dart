import 'package:airplane_entertainment_system/airplane_entertainment_system/airplane_entertainment_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('TopButtonBar', () {
    testWidgets('contains power button', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: TopButtonBar(),
        ),
      );

      expect(find.byIcon(Icons.power_settings_new), findsOneWidget);
      await tester.tap(find.byIcon(Icons.power_settings_new));
    });

    testWidgets('contains brightness button', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: TopButtonBar(),
        ),
      );

      expect(find.byIcon(Icons.brightness_7), findsOneWidget);
      await tester.tap(find.byIcon(Icons.brightness_7));
    });

    testWidgets('contains volume button', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: TopButtonBar(),
        ),
      );

      expect(find.byIcon(Icons.volume_up), findsOneWidget);
      await tester.tap(find.byIcon(Icons.volume_up));
    });

    testWidgets('contains assist button', (tester) async {
      await tester.pumpApp(
        const Scaffold(
          body: TopButtonBar(),
        ),
      );

      expect(find.byIcon(Icons.support), findsOneWidget);
      await tester.tap(find.byIcon(Icons.support));
    });
  });
}
