import 'package:equatable/equatable.dart';

/// {@template music_track}
/// Contains information about a music track.
/// {@endtemplate}
class MusicTrack extends Equatable {
  /// {@macro music_track}
  const MusicTrack({
    required this.index,
    required this.title,
    required this.artist,
    required this.path,
  });

  /// The index of the track in the playlist.
  final int index;

  /// The title of the track.
  final String title;

  /// The author of the track.
  final String artist;

  /// The path to the track file.
  final String path;

  @override
  List<Object?> get props => [index, title, artist, path];
}
