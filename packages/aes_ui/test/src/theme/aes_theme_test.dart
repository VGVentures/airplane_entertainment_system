import 'package:aes_ui/aes_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('$AesTheme', () {
    test('uses material 3', () {
      expect(const AesTheme().themeData.useMaterial3, isTrue);
    });

    test('uses navigationRailTheme', () {
      expect(const AesTheme().themeData.navigationRailTheme, isNotNull);
    });

    group('NavigationBarTheme', () {
      test('uses navigationBarTheme', () {
        expect(const AesTheme().themeData.navigationBarTheme, isNotNull);
      });

      test('uses red icon when selected', () {
        final iconTheme =
            const AesTheme().themeData.navigationBarTheme.iconTheme;
        expect(
          iconTheme!.resolve({WidgetState.selected}),
          const IconThemeData(color: Colors.red),
        );
      });

      test('uses black icon when not selected', () {
        final iconTheme =
            const AesTheme().themeData.navigationBarTheme.iconTheme;
        expect(
          iconTheme!.resolve({WidgetState.disabled}),
          const IconThemeData(color: Colors.black),
        );
      });
    });
  });
}
