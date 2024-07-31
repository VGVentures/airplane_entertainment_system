import 'package:equatable/equatable.dart';
import 'package:flight_api_client/flight_api_client.dart';

/// {@template flight_information}
/// Information about a flight.
/// {@endtemplate}
class FlightInformation extends Equatable {
  /// {@macro flight_information}
  const FlightInformation({
    required this.departureAirport,
    required this.arrivalAirport,
    required this.departureTime,
    required this.arrivalTime,
    required this.timestamp,
  });

  /// The airport the flight departs from.
  final Airport departureAirport;

  /// The airport the flight arrives at.
  final Airport arrivalAirport;

  /// The time the flight departs.
  final DateTime departureTime;

  /// The time the flight arrives.
  final DateTime arrivalTime;

  /// The time the flight information was last updated.
  final DateTime timestamp;

  @override
  List<Object> get props => [
        departureAirport,
        arrivalAirport,
        departureTime,
        arrivalTime,
        timestamp,
      ];
}
