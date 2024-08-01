import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_repository/music_repository.dart';

part 'music_player_state.dart';

class MusicPlayerCubit extends Cubit<MusicPlayerState> {
  MusicPlayerCubit({
    required MusicRepository musicRepository,
    required AudioPlayer player,
  })  : _musicRepository = musicRepository,
        _player = player,
        super(const MusicPlayerState()) {
    _isPlayingSubscription = _player.playingStream.listen(_onIsPlayingChanged);
    _progressSubscription = _player.positionStream.listen(_onProgressChanged);
    _trackSubscription =
        _player.currentIndexStream.listen(_onTrackIndexChanged);
  }

  final MusicRepository _musicRepository;
  late final StreamSubscription<bool> _isPlayingSubscription;
  late final StreamSubscription<Duration> _progressSubscription;
  late final StreamSubscription<int?> _trackSubscription;
  final AudioPlayer _player;

  void _onIsPlayingChanged(bool isPlaying) {
    emit(state.copyWith(isPlaying: isPlaying));
  }

  void _onProgressChanged(Duration position) {
    final duration = _player.duration;
    if (duration == null || duration.inMilliseconds == 0) return;
    final progress = position.inMilliseconds / duration.inMilliseconds;
    emit(state.copyWith(progress: progress));
  }

  void _onTrackIndexChanged(int? index) {
    if (index == null) {
      emit(MusicPlayerState(tracks: state.tracks));
    } else {
      emit(state.copyWith(currentTrackIndex: index));
    }
  }

  void initialize() {
    final tracks = _musicRepository.getTracks();

    if (_player.audioSource == null) {
      final playlist = ConcatenatingAudioSource(
        children: tracks.map((track) => AudioSource.asset(track.path)).toList(),
      );
      _player.setAudioSource(playlist);
    }

    emit(state.copyWith(tracks: tracks));
  }

  void playTrack(MusicTrack track) {
    if (track == state.currentTrack) {
      return togglePlayPause();
    }
    _player
      ..seek(Duration.zero, index: track.index)
      ..play();
  }

  void togglePlayPause() {
    if (state.currentTrack == null) return;
    if (state.isPlaying) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  void seek(double progress) {
    final duration = _player.duration;
    if (duration != null) {
      _player.seek(duration * progress);
    }
  }

  void next() {
    if (state.currentTrack == null) return;
    _player.seekToNext();
  }

  void previous() {
    if (state.currentTrack == null) return;
    _player.seekToPrevious();
  }

  void toggleLoop() {
    final loop = !state.isLoop;
    _player.setLoopMode(loop ? LoopMode.one : LoopMode.off);
    emit(state.copyWith(isLoop: !state.isLoop));
  }

  void toggleShuffle() {
    final shuffle = !state.isShuffle;
    _player.setShuffleModeEnabled(shuffle);
    emit(state.copyWith(isShuffle: !state.isShuffle));
  }

  @override
  Future<void> close() {
    _isPlayingSubscription.cancel();
    _progressSubscription.cancel();
    _trackSubscription.cancel();
    return super.close();
  }
}
