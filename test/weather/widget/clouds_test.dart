import 'package:airplane_entertainment_system/weather/widget/clouds.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Clouds', () {
    testWidgets('fades between clouds when style changes', (tester) async {
      var style = CloudStyle.light;
      late VoidCallback updateStyle;

      await tester.pumpApp(
        StatefulBuilder(
          builder: (context, setState) {
            updateStyle = () => setState(() => style = CloudStyle.medium);
            return Clouds(
              count: 1,
              averageScale: 1,
              averageVelocity: 1,
              style: style,
            );
          },
        ),
      );
      await tester.pump();

      final cloudsFinder = find.byType(Opacity);

      expect(cloudsFinder, findsOneWidget);

      updateStyle();
      await tester.pump();

      expect(cloudsFinder, findsNWidgets(2));

      await tester.pump(const Duration(seconds: 1));

      expect(cloudsFinder, findsOneWidget);
    });

    testWidgets('renders no clouds if style is [CloudStyle.none]',
        (tester) async {
      await tester.pumpApp(
        const Clouds(
          count: 1,
          averageScale: 1,
          averageVelocity: 1,
          style: CloudStyle.none,
        ),
      );
      await tester.pump();

      final cloudsFinder = find.byType(Opacity);
      expect(cloudsFinder, findsNothing);
    });
  });
}
