import 'package:airplane_entertainment_system/music_player/cubit/music_player_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_repository/music_repository.dart';

import '../../helpers/pump_experience.dart';

class _FakeAudioSource extends Fake implements AudioSource {}

void main() {
  group('MusicPlayerCubit', () {
    const tracks = [
      MusicTrack(index: 0, title: 'Title', artist: 'Artist', path: 'path'),
    ];
    late MusicRepository musicRepository;
    late AudioPlayer audioPlayer;

    setUpAll(() {
      registerFallbackValue(_FakeAudioSource());
      registerFallbackValue(LoopMode.off);
    });

    setUp(() {
      musicRepository = MockMusicRepository();

      audioPlayer = MockAudioPlayer();
      when(() => audioPlayer.positionStream)
          .thenAnswer((_) => const Stream.empty());
      when(() => audioPlayer.playingStream)
          .thenAnswer((_) => const Stream.empty());
      when(() => audioPlayer.currentIndexStream)
          .thenAnswer((_) => const Stream.empty());
      when(() => audioPlayer.setAudioSource(any()))
          .thenAnswer((_) async => null);
      when(() => audioPlayer.seek(any(), index: any(named: 'index')))
          .thenAnswer((_) async {});
      when(audioPlayer.pause).thenAnswer((_) async {});
      when(audioPlayer.play).thenAnswer((_) async {});
      when(audioPlayer.seekToNext).thenAnswer((_) async {});
      when(audioPlayer.seekToPrevious).thenAnswer((_) async {});
      when(() => audioPlayer.setLoopMode(any())).thenAnswer((_) async {});
      when(() => audioPlayer.setShuffleModeEnabled(any()))
          .thenAnswer((_) async {});
    });

    MusicPlayerCubit build() => MusicPlayerCubit(
          musicRepository: musicRepository,
          player: audioPlayer,
        );

    blocTest<MusicPlayerCubit, MusicPlayerState>(
      'initial state is default',
      build: build,
      verify: (cubit) {
        expect(cubit.state, const MusicPlayerState());
      },
    );

    blocTest<MusicPlayerCubit, MusicPlayerState>(
      'initial state is default',
      build: build,
      verify: (cubit) {
        expect(cubit.state, const MusicPlayerState());
      },
    );

    blocTest<MusicPlayerCubit, MusicPlayerState>(
      'updates [isPlaying] when [playingStream] emits',
      setUp: () => when(() => audioPlayer.playingStream)
          .thenAnswer((_) => Stream.value(true)),
      build: build,
      expect: () => const [
        MusicPlayerState(isPlaying: true),
      ],
    );

    blocTest<MusicPlayerCubit, MusicPlayerState>(
      'updates [progress] when [positionStream] emits',
      setUp: () {
        when(() => audioPlayer.duration)
            .thenReturn(const Duration(seconds: 10));
        when(() => audioPlayer.positionStream)
            .thenAnswer((_) => Stream.value(const Duration(seconds: 1)));
      },
      build: build,
      expect: () => const [
        MusicPlayerState(progress: 0.1),
      ],
    );

    blocTest<MusicPlayerCubit, MusicPlayerState>(
      'updates [currentTrackIndex] when [currentIndexStream] emits value',
      setUp: () => when(() => audioPlayer.currentIndexStream)
          .thenAnswer((_) => Stream.value(0)),
      build: build,
      expect: () => const [
        MusicPlayerState(currentTrackIndex: 0),
      ],
    );

    blocTest<MusicPlayerCubit, MusicPlayerState>(
      'clears state when [currentIndexStream] emits null (keeping tracks)',
      setUp: () => when(() => audioPlayer.currentIndexStream)
          .thenAnswer((_) => Stream.value(null)),
      seed: () => const MusicPlayerState(
        tracks: tracks,
        currentTrackIndex: 0,
        isPlaying: true,
      ),
      build: build,
      expect: () => const [
        MusicPlayerState(tracks: tracks),
      ],
    );

    group('initialize', () {
      setUp(() {
        when(musicRepository.getTracks).thenReturn(tracks);
        when(() => audioPlayer.audioSource).thenReturn(_FakeAudioSource());
        when(() => audioPlayer.audioSource).thenReturn(null);
      });

      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'loads music tracks',
        build: build,
        act: (cubit) => cubit.initialize(),
        expect: () => const [
          MusicPlayerState(tracks: tracks),
        ],
      );

      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'sets tracks as audio source in player if it is not set',
        setUp: () => when(() => audioPlayer.audioSource).thenReturn(null),
        build: build,
        act: (cubit) => cubit.initialize(),
        verify: (_) => verify(
          () => audioPlayer.setAudioSource(
            any(that: isA<ConcatenatingAudioSource>()),
          ),
        ).called(1),
      );
    });

    group('playTrack', () {
      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'calls [audioPlayer.seek] with at the track index',
        build: build,
        act: (cubit) => cubit.playTrack(tracks[0]),
        verify: (_) => verify(
          () => audioPlayer.seek(
            Duration.zero,
            index: 0,
          ),
        ).called(1),
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
        'calls [audioPlayer.play] when the player is paused',
        build: build,
        seed: () => const MusicPlayerState(
          tracks: tracks,
          currentTrackIndex: 0,
        ),
        act: (cubit) => cubit.togglePlayPause(),
        verify: (_) => verify(audioPlayer.play).called(1),
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
      setUp(() {
        when(() => audioPlayer.duration)
            .thenReturn(const Duration(seconds: 10));
      });

      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'calls [audioPlayer.seek] with the corresponding duration and',
        build: build,
        seed: () => const MusicPlayerState(
          tracks: tracks,
          currentTrackIndex: 0,
        ),
        act: (cubit) => cubit.seek(0.5),
        verify: (_) => verify(
          () => audioPlayer.seek(
            const Duration(seconds: 5),
          ),
        ).called(1),
      );

      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'calls [audioPlayer.play]',
        build: build,
        seed: () => const MusicPlayerState(
          tracks: tracks,
          currentTrackIndex: 0,
        ),
        act: (cubit) => cubit.seek(0.5),
        verify: (_) => verify(audioPlayer.play).called(1),
      );
    });

    group('next', () {
      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'calls [audioPlayer.seekToNext]',
        build: build,
        seed: () => const MusicPlayerState(
          tracks: tracks,
          currentTrackIndex: 0,
        ),
        act: (cubit) => cubit.next(),
        verify: (_) => verify(audioPlayer.seekToNext).called(1),
      );
    });

    group('previous', () {
      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'calls [audioPlayer.seekToPrevious]',
        build: build,
        seed: () => const MusicPlayerState(
          tracks: tracks,
          currentTrackIndex: 0,
        ),
        act: (cubit) => cubit.previous(),
        verify: (_) => verify(audioPlayer.seekToPrevious).called(1),
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
        'calls [audioPlayer.setLoopMode] with [LoopMode.one] when activating',
        build: build,
        seed: () => const MusicPlayerState(
          tracks: tracks,
          currentTrackIndex: 0,
        ),
        act: (cubit) => cubit.toggleLoop(),
        verify: (_) =>
            verify(() => audioPlayer.setLoopMode(LoopMode.one)).called(1),
      );

      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'calls [audioPlayer.setLoopMode] with [LoopMode.off] when deactivating',
        build: build,
        seed: () => const MusicPlayerState(
          tracks: tracks,
          currentTrackIndex: 0,
          isLoop: true,
        ),
        act: (cubit) => cubit.toggleLoop(),
        verify: (_) =>
            verify(() => audioPlayer.setLoopMode(LoopMode.off)).called(1),
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
        expect: () => const [
          MusicPlayerState(
            tracks: tracks,
            currentTrackIndex: 0,
            isShuffle: true,
          ),
        ],
      );

      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'updates [isShuffle] to false when it is true',
        build: build,
        seed: () => const MusicPlayerState(
          tracks: tracks,
          currentTrackIndex: 0,
          isShuffle: true,
        ),
        act: (cubit) => cubit.toggleShuffle(),
        expect: () => const [
          MusicPlayerState(
            tracks: tracks,
            currentTrackIndex: 0,
          ),
        ],
      );

      blocTest<MusicPlayerCubit, MusicPlayerState>(
        'calls [audioPlayer.setShuffleModeEnabled]',
        build: build,
        seed: () => const MusicPlayerState(
          tracks: tracks,
          currentTrackIndex: 0,
        ),
        act: (cubit) => cubit.toggleShuffle(),
        verify: (_) =>
            verify(() => audioPlayer.setShuffleModeEnabled(true)).called(1),
      );
    });
  });
}
