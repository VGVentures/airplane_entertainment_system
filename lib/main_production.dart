import 'package:airplane_entertainment_system/app/app.dart';
import 'package:airplane_entertainment_system/bootstrap.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flight_api_client/flight_api_client.dart';
import 'package:flight_information_repository/flight_information_repository.dart';
import 'package:music_repository/music_repository.dart';
import 'package:weather_api_client/weather_api_client.dart';
import 'package:weather_repository/weather_repository.dart';

void main() {
  bootstrap(() {
    final weatherRepository = WeatherRepository(WeatherApiClient());
    final musicRepository = MusicRepository();
    final audioPlayer = AudioPlayer();
    final flightInformationRepository =
        FlightInformationRepository(FlightApiClient());

    return App(
      weatherRepository: weatherRepository,
      musicRepository: musicRepository,
      audioPlayer: audioPlayer,
      flightInformationRepository: flightInformationRepository,
    );
  });
}
