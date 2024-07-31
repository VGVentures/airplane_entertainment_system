import 'package:airplane_entertainment_system/flight_tracking/flight_tracking.dart';
import 'package:airplane_entertainment_system/overview/overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('$OverviewPage', () {
    testWidgets('contains welcome copy', (tester) async {
      await tester.pumpApp(const OverviewPage());

      expect(find.byType(WelcomeCopy), findsOneWidget);
    });

    testWidgets('contains flight tracker', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1600, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpApp(const OverviewPage());

      await tester.dragUntilVisible(
        find.byType(FlightTrackingCard),
        find.byType(ListView),
        const Offset(0, -50),
      );

      expect(find.byType(FlightTrackingCard), findsOneWidget);
    });
  });
}
