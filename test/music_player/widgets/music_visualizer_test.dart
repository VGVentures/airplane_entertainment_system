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
            child: const MusicVisualizer(isActive: true),
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

    testWidgets('changes animation when activated', (tester) async {
      var isActive = false;
      late void Function() activate;

      await tester.pumpWidget(
        MaterialApp(
          home: DefaultAssetBundle(
            bundle: FakeAssetBundle(),
            child: StatefulBuilder(
              builder: (context, setState) {
                activate = () => setState(() => isActive = true);
                return MusicVisualizer(isActive: isActive);
              },
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));

      activate();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      final state = tester.state<MusicVisualizerState>(
        find.byType(MusicVisualizer),
      );
      expect(state.extensionController.value, 1);
    });

    testWidgets('changes animation when deactivated', (tester) async {
      var isActive = true;
      late void Function() deactivate;

      await tester.pumpWidget(
        MaterialApp(
          home: DefaultAssetBundle(
            bundle: FakeAssetBundle(),
            child: StatefulBuilder(
              builder: (context, setState) {
                deactivate = () => setState(() => isActive = false);
                return MusicVisualizer(isActive: isActive);
              },
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));

      deactivate();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      final state = tester.state<MusicVisualizerState>(
        find.byType(MusicVisualizer),
      );
      expect(state.extensionController.value, 0);
    });
  });
}
