import 'package:airplane_entertainment_system/app/app.dart';
import 'package:airplane_entertainment_system/bootstrap.dart';
import 'package:flight_api_client/flight_api_client.dart';
import 'package:flight_information_repository/flight_information_repository.dart';

void main() {
  bootstrap(() {
    final flightInformationRepository =
        FlightInformationRepository(FlightApiClient());

    return App(
      flightInformationRepository: flightInformationRepository,
    );
  });
}
