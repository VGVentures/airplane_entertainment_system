import 'package:airplane_entertainment_system/l10n/l10n.dart';
import 'package:airplane_entertainment_system/overview/overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Movie Card', () {
    testWidgets('finds one MovieCard Widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: MovieCard(),
          ),
        ),
      );
      expect(find.byType(MovieCard), findsOneWidget);
    });
  });
}
