import 'dart:convert';

import 'package:airplane_entertainment_system/music_player/music_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _data = [
  [0.0, 0.0, 0.0, 0.3, 0.4],
  [1.0, 1.0, 1.0, 0.5, 0.5],
];

class FakeAssetBundle extends Fake implements AssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) {
    if (key == 'assets/spectrogram.json') {
      return Future.value(jsonEncode(_data));
    }

    throw UnimplementedError();
  }
}

void main() {
  group('MusicVisualizer', () {
    testWidgets('loads data and plays an animation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DefaultAssetBundle(
            bundle: FakeAssetBundle(),
            child: const MusicVisualizer(),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byType(MusicVisualizer), findsOneWidget);
    });
  });
}
