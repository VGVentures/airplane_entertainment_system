part of 'music_player_cubit.dart';

class MusicPlayerState extends Equatable {
  const MusicPlayerState({
    this.tracks = const [],
    this.currentTrackIndex,
    this.progress = 0.0,
    this.isPlaying = false,
    this.isLoop = false,
    this.isShuffle = false,
  });

  final List<MusicTrack> tracks;
  final int? currentTrackIndex;
  final double progress;
  final bool isPlaying;
  final bool isLoop;
  final bool isShuffle;

  MusicTrack? get currentTrack => tracks.isNotEmpty && currentTrackIndex != null
      ? tracks[currentTrackIndex!]
      : null;

  @override
  List<Object?> get props => [
        tracks,
        currentTrackIndex,
        isPlaying,
        progress,
        isLoop,
        isShuffle,
      ];

  MusicPlayerState copyWith({
    List<MusicTrack>? tracks,
    int? currentTrackIndex,
    double? progress,
    bool? isPlaying,
    bool? isLoop,
    bool? isShuffle,
  }) {
    return MusicPlayerState(
      tracks: tracks ?? this.tracks,
      currentTrackIndex: currentTrackIndex ?? this.currentTrackIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      progress: progress ?? this.progress,
      isLoop: isLoop ?? this.isLoop,
      isShuffle: isShuffle ?? this.isShuffle,
    );
  }
}
