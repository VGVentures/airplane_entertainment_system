// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:music_repository/music_repository.dart';

void main() {
  group('MusicTrack', () {
    group('supports instance comparison', () {
      test('with equal instances', () {
        expect(
          MusicTrack(
            index: 0,
            title: 'title',
            artist: 'artist',
            path: 'path',
          ),
          MusicTrack(
            index: 0,
            title: 'title',
            artist: 'artist',
            path: 'path',
          ),
        );
      });

      test('with non-equal instances', () {
        expect(
          MusicTrack(
            index: 0,
            title: 'title',
            artist: 'artist',
            path: 'path',
          ),
          isNot(
            MusicTrack(
              index: 1,
              title: 'title1',
              artist: 'artist1',
              path: 'path1',
            ),
          ),
        );
      });
    });
  });
}
