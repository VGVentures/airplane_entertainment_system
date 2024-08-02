part of 'music_player_cubit.dart';

class MusicPlayerState extends Equatable {
  const MusicPlayerState({
    this.tracks = const [],
    this.currentTrackIndex,
    this.duration,
    this.progress = 0.0,
    this.isPlaying = false,
    this.isLoop = false,
    this.shuffleIndexes = const [],
    this.mute = false,
  });

  final List<MusicTrack> tracks;
  final int? currentTrackIndex;
  final Duration? duration;
  final double progress;
  final bool isPlaying;
  final bool isLoop;
  final List<int> shuffleIndexes;
  final bool mute;

  bool get isShuffle => shuffleIndexes.isNotEmpty;

  MusicTrack? get currentTrack => tracks.isNotEmpty && currentTrackIndex != null
      ? tracks[currentTrackIndex!]
      : null;

  @override
  List<Object?> get props => [
        tracks,
        currentTrackIndex,
        isPlaying,
        duration,
        progress,
        isLoop,
        shuffleIndexes,
        mute,
      ];

  MusicPlayerState copyWith({
    List<MusicTrack>? tracks,
    int? currentTrackIndex,
    Duration? duration,
    double? progress,
    bool? isPlaying,
    bool? isLoop,
    List<int>? shuffleIndexes,
    bool? mute,
  }) {
    return MusicPlayerState(
      tracks: tracks ?? this.tracks,
      currentTrackIndex: currentTrackIndex ?? this.currentTrackIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      duration: duration ?? this.duration,
      progress: progress ?? this.progress,
      isLoop: isLoop ?? this.isLoop,
      shuffleIndexes: shuffleIndexes ?? this.shuffleIndexes,
      mute: mute ?? this.mute,
    );
  }
}
