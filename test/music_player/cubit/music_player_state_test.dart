// ignore_for_file: prefer_const_constructors

import 'package:airplane_entertainment_system/music_player/music_player.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_repository/music_repository.dart';

class _MockMusicTrack extends Mock implements MusicTrack {}

void main() {
  group('MusicPlayerState', () {
    group('supports instances comparison', () {
      test('with equal instances', () {
        final tracks = [_MockMusicTrack()];
        expect(
          MusicPlayerState(
            tracks: tracks,
            currentTrackIndex: 0,
            progress: 10,
            isPlaying: true,
            isLoop: true,
            isShuffle: true,
          ),
          MusicPlayerState(
            tracks: tracks,
            currentTrackIndex: 0,
            progress: 10,
            isPlaying: true,
            isLoop: true,
            isShuffle: true,
          ),
        );
      });

      test('with non equal instances', () {
        final tracks = [_MockMusicTrack()];
        expect(
          MusicPlayerState(
            tracks: tracks,
            currentTrackIndex: 0,
            progress: 10,
            isPlaying: true,
            isLoop: true,
            isShuffle: true,
          ),
          isNot(MusicPlayerState()),
        );
      });
    });
  });
}
