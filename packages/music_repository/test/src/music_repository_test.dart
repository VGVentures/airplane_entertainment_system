// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:music_repository/music_repository.dart';

void main() {
  group('MusicRepository', () {
    test('can be instantiated', () {
      expect(MusicRepository(), isNotNull);
    });

    test('getTracks returns a list of [MusicTrack]', () {
      expect(MusicRepository().getTracks(), isA<List<MusicTrack>>());
    });
  });
}
