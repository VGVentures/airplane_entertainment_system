import 'package:music_repository/gen/assets.gen.dart';
import 'package:music_repository/music_repository.dart';

/// {@template music_repository}
/// Repository of music tracks.
/// {@endtemplate}
class MusicRepository {
  /// {@macro music_repository}
  MusicRepository();

  /// Returns the list of available music tracks.
  List<MusicTrack> getTracks() {
    const basePath = 'packages/music_repository/';
    final tracks = Assets.lib.tracks;
    return [
      MusicTrack(
        index: 0,
        title: 'Arpent',
        artist: 'Kevin MacLead',
        path: basePath + tracks.arpent,
      ),
      MusicTrack(
        index: 1,
        title: 'Groovin',
        artist: 'Bryan Boyko',
        path: basePath + tracks.groovin,
      ),
      MusicTrack(
        index: 2,
        title: 'Motions',
        artist: 'Rafael Krux',
        path: basePath + tracks.motions,
      ),
      MusicTrack(
        index: 3,
        title: 'Trip Up North',
        artist: 'Bryan Teoh',
        path: basePath + tracks.tripUpNorth,
      ),
      MusicTrack(
        index: 4,
        title: 'Windy Old Weather',
        artist: 'Kevin MacLead',
        path: basePath + tracks.windyOldWeather,
      ),
    ];
  }
}
