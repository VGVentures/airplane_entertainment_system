import 'package:airplane_entertainment_system/music_player/cubit/music_player_cubit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_repository/music_repository.dart';

import '../../helpers/pump_experience.dart';

class _FakeAssetSource extends Fake implements AssetSource {}

class _MockAudioCache extends Mock implements AudioCache {}

void main() {
  group('MusicPlayerCubit', () {
    const tracks = [
      MusicTrack(index: 0, title: 'Title0', artist: 'Artist0', path: 'path0'),
      MusicTrack(index: 1, title: 'Title1', artist: 'Artist1', path: 'path1'),
    ];
    late MusicRepository musicRepository;
    late AudioCache audioCache;
    late AudioPlayer audioPlayer;

    setUpAll(() {
      registerFallbackValue(_FakeAssetSource());
      registerFallbackValue(ReleaseMode.loop);
      registerFallbackValue(Duration.zero);
    });

    setUp(() {
      musicRepository = MockMusicRepository();

      audioPlayer = MockAudioPlayer();
      when(() => audioPlayer.onPositionChanged)
          .thenAnswer((_) => const Stream.empty());
      when(() => audioPlayer.onPlayerStateChanged)
          .thenAnswer((_) => const Stream.empty());
      when(() => audioPlayer.play(any())).thenAnswer((_) async {});
      when(() => audioPlayer.seek(any())).thenAnswer((_) async {});
      when(audioPlayer.getDuration).thenAnswer((_) async => null);
      when(audioPlayer.pause).thenAnswer((_) async {});
      when(audioPlayer.resume).thenAnswer((_) async {});
      when(audioPlayer.release).thenAnswer((_) async {});
      when(() => audioPlayer.setReleaseMode(any())).thenAnswer((_) async {
        return;
      });

      audioCache = _MockAudioCache();
      when(() => audioPlayer.audioCache).thenReturn(audioCache);
    });

    MusicPlayerCubit build() => MusicPlayerCubit(
          musicRepository: musicRepository,
          player: audioPlayer,
        );

    blocTest<MusicPlayerCubit, MusicPlayerState>(
      'updates [progress] when [onPositionChanged] emits',
      seed: () => const MusicPlayerState(
        duration: Duration(seconds: 10),
      ),
      setUp: () {
        when(() => audioPlayer.onPositionChanged)
            .thenAnswer((_) => Stream.value(const Duration(seconds: 1)));
      },
      build: build,
      expect: () => const [
        MusicPlayerState(duration: Duration(seconds: 10), progress: 0.1),
      ],
    );

    group('when [onPlayerStateChanged] emits', () {
      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'updates [isPlaying]',
        setUp: () => when(() => audioPlayer.onPlayerStateChanged)
            .thenAnswer((_) => Stream.value(PlayerState.playing)),
        build: build,
        expect: () => const [
          MusicPlayerState(isPlaying: true),
        ],
      );

      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'moves to next track if state is [PlayerState.completed]',
        setUp: () => when(() => audioPlayer.onPlayerStateChanged)
            .thenAnswer((_) => Stream.value(PlayerState.completed)),
        seed: () => const MusicPlayerState(
          tracks: tracks,
          currentTrackIndex: 0,
        ),
        build: build,
        expect: () => [
          const MusicPlayerState(
            tracks: tracks,
            currentTrackIndex: 1,
          ),
        ],
      );
    });

    group('initialize', () {
      setUp(() {
        when(musicRepository.getTracks).thenReturn(tracks);
      });

      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'loads music tracks',
        build: build,
        act: (cubit) => cubit.initialize(),
        expect: () => const [
          MusicPlayerState(tracks: tracks),
        ],
      );
    });

    group('playTrack', () {
      setUp(() {
        when(audioPlayer.getDuration).thenAnswer(
          (_) async => const Duration(seconds: 10),
        );
      });

      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'calls [audioPlayer.play]',
        build: build,
        act: (cubit) => cubit.playTrack(tracks[0]),
        verify: (_) => verify(
          () => audioPlayer.play(
            any(
              that: isA<AssetSource>().having(
                (s) => s.path,
                'path',
                equals(tracks[0].path),
              ),
            ),
          ),
        ).called(1),
      );

      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'emits track index and duration',
        build: build,
        seed: () => const MusicPlayerState(tracks: tracks),
        act: (cubit) => cubit.playTrack(tracks[0]),
        expect: () => const [
          MusicPlayerState(
            tracks: tracks,
            currentTrackIndex: 0,
            duration: Duration(seconds: 10),
          ),
        ],
      );

      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'calls [audioPlayer.pause] when the track is already playing',
        build: build,
        seed: () => const MusicPlayerState(
          tracks: tracks,
          currentTrackIndex: 0,
          isPlaying: true,
        ),
        act: (cubit) => cubit.playTrack(tracks[0]),
        verify: (_) => verify(audioPlayer.pause).called(1),
      );
    });

    group('togglePlayPause', () {
      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'plays first track if current track is null',
        build: build,
        seed: () => const MusicPlayerState(
          tracks: tracks,
        ),
        act: (cubit) => cubit.togglePlayPause(),
        verify: (_) => verify(
          () => audioPlayer.play(
            any(
              that: isA<AssetSource>().having(
                (s) => s.path,
                'path',
                equals(tracks[0].path),
              ),
            ),
          ),
        ).called(1),
      );

      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'calls [audioPlayer.resume] when the player is paused',
        build: build,
        seed: () => const MusicPlayerState(
          tracks: tracks,
          currentTrackIndex: 0,
        ),
        act: (cubit) => cubit.togglePlayPause(),
        verify: (_) => verify(audioPlayer.resume).called(1),
      );

      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'calls [audioPlayer.pause] when the player is playing',
        build: build,
        seed: () => const MusicPlayerState(
          tracks: tracks,
          currentTrackIndex: 0,
          isPlaying: true,
        ),
        act: (cubit) => cubit.togglePlayPause(),
        verify: (_) => verify(audioPlayer.pause).called(1),
      );
    });

    group('seek', () {
      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'calls [audioPlayer.seek] with the corresponding duration and',
        build: build,
        seed: () => const MusicPlayerState(
          tracks: tracks,
          currentTrackIndex: 0,
          duration: Duration(seconds: 10),
        ),
        act: (cubit) => cubit.seek(0.5),
        verify: (_) => verify(
          () => audioPlayer.seek(
            const Duration(seconds: 5),
          ),
        ).called(1),
      );
    });

    group('next', () {
      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'plays next track in list',
        build: build,
        seed: () => const MusicPlayerState(
          tracks: tracks,
          currentTrackIndex: 0,
        ),
        act: (cubit) => cubit.next(),
        verify: (_) => verify(
          () => audioPlayer.play(
            any(
              that: isA<AssetSource>().having(
                (s) => s.path,
                'path',
                equals(tracks[1].path),
              ),
            ),
          ),
        ).called(1),
      );

      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'plays first track if current is the last one',
        build: build,
        seed: () => const MusicPlayerState(
          tracks: tracks,
          currentTrackIndex: 1,
        ),
        act: (cubit) => cubit.previous(),
        verify: (_) => verify(
          () => audioPlayer.play(
            any(
              that: isA<AssetSource>().having(
                (s) => s.path,
                'path',
                equals(tracks[0].path),
              ),
            ),
          ),
        ).called(1),
      );

      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'plays next track in shuffle list if shuffling is enabled',
        build: build,
        seed: () => const MusicPlayerState(
          tracks: tracks,
          currentTrackIndex: 1,
          shuffleIndexes: [1, 0],
        ),
        act: (cubit) => cubit.next(),
        verify: (_) => verify(
          () => audioPlayer.play(
            any(
              that: isA<AssetSource>().having(
                (s) => s.path,
                'path',
                equals(tracks[0].path),
              ),
            ),
          ),
        ).called(1),
      );

      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'plays first track in shuffle list if shuffling is enabled and '
        'current track is the last one',
        build: build,
        seed: () => const MusicPlayerState(
          tracks: tracks,
          currentTrackIndex: 0,
          shuffleIndexes: [1, 0],
        ),
        act: (cubit) => cubit.next(),
        verify: (_) => verify(
          () => audioPlayer.play(
            any(
              that: isA<AssetSource>().having(
                (s) => s.path,
                'path',
                equals(tracks[1].path),
              ),
            ),
          ),
        ).called(1),
      );
    });

    group('previous', () {
      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'plays previous track in list',
        build: build,
        seed: () => const MusicPlayerState(
          tracks: tracks,
          currentTrackIndex: 1,
        ),
        act: (cubit) => cubit.previous(),
        verify: (_) => verify(
          () => audioPlayer.play(
            any(
              that: isA<AssetSource>().having(
                (s) => s.path,
                'path',
                equals(tracks[0].path),
              ),
            ),
          ),
        ).called(1),
      );

      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'plays last track if current is the first one',
        build: build,
        seed: () => const MusicPlayerState(
          tracks: tracks,
          currentTrackIndex: 0,
        ),
        act: (cubit) => cubit.previous(),
        verify: (_) => verify(
          () => audioPlayer.play(
            any(
              that: isA<AssetSource>().having(
                (s) => s.path,
                'path',
                equals(tracks[1].path),
              ),
            ),
          ),
        ).called(1),
      );

      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'plays previous track in shuffle list if shuffling is enabled',
        build: build,
        seed: () => const MusicPlayerState(
          tracks: tracks,
          currentTrackIndex: 0,
          shuffleIndexes: [0, 1],
        ),
        act: (cubit) => cubit.previous(),
        verify: (_) => verify(
          () => audioPlayer.play(
            any(
              that: isA<AssetSource>().having(
                (s) => s.path,
                'path',
                equals(tracks[1].path),
              ),
            ),
          ),
        ).called(1),
      );

      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'plays last track in shuffle list if shuffling is enabled and '
        'current track is the first one',
        build: build,
        seed: () => const MusicPlayerState(
          tracks: tracks,
          currentTrackIndex: 1,
          shuffleIndexes: [0, 1],
        ),
        act: (cubit) => cubit.previous(),
        verify: (_) => verify(
          () => audioPlayer.play(
            any(
              that: isA<AssetSource>().having(
                (s) => s.path,
                'path',
                equals(tracks[0].path),
              ),
            ),
          ),
        ).called(1),
      );
    });

    group('toggleLoop', () {
      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'updates [isLoop] to true when it is false',
        build: build,
        seed: () => const MusicPlayerState(
          tracks: tracks,
          currentTrackIndex: 0,
        ),
        act: (cubit) => cubit.toggleLoop(),
        expect: () => const [
          MusicPlayerState(
            tracks: tracks,
            currentTrackIndex: 0,
            isLoop: true,
          ),
        ],
      );

      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'updates [isLoop] to false when it is true',
        build: build,
        seed: () => const MusicPlayerState(
          tracks: tracks,
          currentTrackIndex: 0,
          isLoop: true,
        ),
        act: (cubit) => cubit.toggleLoop(),
        expect: () => const [
          MusicPlayerState(
            tracks: tracks,
            currentTrackIndex: 0,
          ),
        ],
      );

      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'calls [audioPlayer.setReleaseMode] with [ReleaseMode.loop] '
        'when activating',
        build: build,
        seed: () => const MusicPlayerState(
          tracks: tracks,
          currentTrackIndex: 0,
        ),
        act: (cubit) => cubit.toggleLoop(),
        verify: (_) =>
            verify(() => audioPlayer.setReleaseMode(ReleaseMode.loop))
                .called(1),
      );

      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'calls [audioPlayer.setReleaseMode] with [ReleaseMode.release] '
        'when deactivating',
        build: build,
        seed: () => const MusicPlayerState(
          tracks: tracks,
          currentTrackIndex: 0,
          isLoop: true,
        ),
        act: (cubit) => cubit.toggleLoop(),
        verify: (_) =>
            verify(() => audioPlayer.setReleaseMode(ReleaseMode.release))
                .called(1),
      );
    });

    group('toggleShuffle', () {
      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'updates [isShuffle] to true when it is false',
        build: build,
        seed: () => const MusicPlayerState(
          tracks: tracks,
          currentTrackIndex: 0,
        ),
        act: (cubit) => cubit.toggleShuffle(),
        expect: () => [
          isA<MusicPlayerState>().having(
            (s) => s.isShuffle,
            'isShuffle',
            isTrue,
          ),
        ],
      );

      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'updates [isShuffle] to false when it is true',
        build: build,
        seed: () => const MusicPlayerState(
          tracks: tracks,
          currentTrackIndex: 0,
          shuffleIndexes: [0],
        ),
        act: (cubit) => cubit.toggleShuffle(),
        expect: () => [
          isA<MusicPlayerState>().having(
            (s) => s.isShuffle,
            'isShuffle',
            isFalse,
          ),
        ],
      );
    });
  });
}
