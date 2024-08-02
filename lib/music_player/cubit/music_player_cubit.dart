import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:music_repository/music_repository.dart';

part 'music_player_state.dart';

class MusicPlayerCubit extends Cubit<MusicPlayerState> {
  MusicPlayerCubit({
    required MusicRepository musicRepository,
    required AudioPlayer player,
  })  : _musicRepository = musicRepository,
        _player = player,
        super(const MusicPlayerState()) {
    _isPlayingSubscription =
        _player.onPlayerStateChanged.listen(_onIsPlayingChanged);
    _progressSubscription =
        _player.onPositionChanged.listen(_onProgressChanged);

    _player.setVolume(1);
  }

  final MusicRepository _musicRepository;
  late final StreamSubscription<PlayerState> _isPlayingSubscription;
  late final StreamSubscription<Duration> _progressSubscription;
  final AudioPlayer _player;

  void _onIsPlayingChanged(PlayerState playerState) {
    if (playerState == PlayerState.completed) {
      if (!state.isLoop) next();
    } else {
      emit(state.copyWith(isPlaying: playerState == PlayerState.playing));
    }
  }

  void _onProgressChanged(Duration position) {
    final duration = state.duration;
    if (duration == null || duration.inSeconds == 0) return;
    final progress = position.inSeconds / duration.inSeconds;
    emit(state.copyWith(progress: progress));
  }

  void initialize() {
    // Allows loading assets from another package.
    _player.audioCache.prefix = '';
    final tracks = _musicRepository.getTracks();
    emit(state.copyWith(tracks: tracks));
  }

  void playTrack(MusicTrack track) {
    if (track == state.currentTrack) {
      return togglePlayPause();
    }
    _loadAndPlayTrack(track);
  }

  Future<void> _loadAndPlayTrack(MusicTrack track) async {
    await _player.play(AssetSource(track.path));
    final duration = await _player.getDuration();
    emit(
      state.copyWith(
        currentTrackIndex: state.tracks.indexOf(track),
        duration: duration,
      ),
    );
  }

  void togglePlayPause() {
    if (state.currentTrack == null) {
      playTrack(state.tracks.first);
    }
    if (state.isPlaying) {
      _player.pause();
    } else {
      _player.resume();
    }
  }

  void seek(double progress) {
    final duration = state.duration;
    if (duration != null) {
      _player.seek(duration * progress);
    }
  }

  void next() {
    final currentTrackIndex = state.currentTrackIndex;
    if (currentTrackIndex == null) return;

    final nextTrackIndex = _nextTrackIndex();
    final nextTrack = state.tracks[nextTrackIndex];
    _loadAndPlayTrack(nextTrack);

    emit(state.copyWith(currentTrackIndex: nextTrackIndex));
  }

  int _nextTrackIndex() {
    final currentTrackIndex = state.currentTrackIndex;
    if (currentTrackIndex == null) return 0;

    if (state.isShuffle) {
      final currentShuffleIndex =
          state.shuffleIndexes.indexOf(currentTrackIndex);
      final nextShuffleIndex =
          (currentShuffleIndex + 1) % state.shuffleIndexes.length;
      return state.shuffleIndexes[nextShuffleIndex];
    } else {
      return (currentTrackIndex + 1) % state.tracks.length;
    }
  }

  void previous() {
    final currentTrackIndex = state.currentTrackIndex;
    if (currentTrackIndex == null) return;

    final previousTrackIndex = _previousTrackIndex();
    final previousTrack = state.tracks[previousTrackIndex];
    _loadAndPlayTrack(previousTrack);

    emit(state.copyWith(currentTrackIndex: previousTrackIndex));
  }

  int _previousTrackIndex() {
    final currentTrackIndex = state.currentTrackIndex;
    if (currentTrackIndex == null) return 0;

    if (state.isShuffle) {
      final currentShuffleIndex =
          state.shuffleIndexes.indexOf(currentTrackIndex);
      final previousShuffleIndex = currentShuffleIndex == 0
          ? state.shuffleIndexes.length - 1
          : currentShuffleIndex - 1;
      return state.shuffleIndexes[previousShuffleIndex];
    } else {
      return currentTrackIndex == 0
          ? state.tracks.length - 1
          : currentTrackIndex - 1;
    }
  }

  void toggleLoop() {
    final isLoop = !state.isLoop;
    final releaseMode = isLoop ? ReleaseMode.loop : ReleaseMode.release;
    _player.setReleaseMode(releaseMode);
    emit(state.copyWith(isLoop: isLoop));
  }

  void toggleShuffle() {
    if (state.isShuffle) {
      emit(state.copyWith(shuffleIndexes: []));
    } else {
      final shuffledIndexes =
          List<int>.generate(state.tracks.length, (index) => index)..shuffle();
      emit(state.copyWith(shuffleIndexes: shuffledIndexes));
    }
  }

  void toggleMute() {
    final mute = !state.mute;
    _player.setVolume(mute ? 0 : 1);
    emit(state.copyWith(mute: mute));
  }

  @override
  Future<void> close() {
    _isPlayingSubscription.cancel();
    _progressSubscription.cancel();
    _player.release();
    return super.close();
  }
}
