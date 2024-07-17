import 'package:airplane_entertainment_system/overview/overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('OverviewPage', () {
    testWidgets('contains welcome copy', (tester) async {
      await tester.pumpExperience(const OverviewPage());

      expect(find.byType(WelcomeCopy), findsOneWidget);
    });

    testWidgets('contains flight tracker', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1600, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpExperience(const OverviewPage());

      await tester.dragUntilVisible(
        find.byType(FlightTrackingCard),
        find.byType(ListView),
        const Offset(0, -50),
      );

      expect(find.byType(FlightTrackingCard), findsOneWidget);
    });
  });
}
