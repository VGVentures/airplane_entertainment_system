import 'dart:async';

import 'package:flight_api_client/flight_api_client.dart';
import 'package:rxdart/subjects.dart';

/// {@template flight_information_repository}
/// A repository for the flight information.
/// {@endtemplate}
class FlightInformationRepository {
  /// {@macro flight_information_repository}
  FlightInformationRepository(this._flightApiClient);

  final FlightApiClient _flightApiClient;

  BehaviorSubject<FlightInformation>? _flightController;

  /// Retrieves the flight information.
  Stream<FlightInformation> get flightInformation {
    if (_flightController == null) {
      _flightController = BehaviorSubject();

      _flightApiClient.flightInformation.listen((flightInformation) {
        _flightController!.add(flightInformation);
      });
    }

    return _flightController!.stream;
  }
}
