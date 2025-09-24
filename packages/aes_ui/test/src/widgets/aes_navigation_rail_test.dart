import 'package:aes_ui/aes_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('$AesNavigationRail', () {
    const destinations = [
      Destination(
        Icon(Icons.airplanemode_active),
        'Airplane',
      ),
      Destination(
        Icon(Icons.headset),
        'Music',
      ),
    ];

    testWidgets('finds one $AesNavigationRail widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AesNavigationRail(
              destinations: destinations,
              selectedIndex: 0,
            ),
          ),
        ),
      );
      expect(find.byType(AesNavigationRail), findsOneWidget);
    });
  });
}
