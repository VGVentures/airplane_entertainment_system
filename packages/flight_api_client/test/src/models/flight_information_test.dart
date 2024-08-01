// ignore_for_file: prefer_const_constructors

import 'package:flight_api_client/flight_api_client.dart';
import 'package:test/test.dart';

void main() {
  group('$FlightInformation', () {
    test('can be instantiated', () {
      expect(
        FlightInformation(
          departureAirport: Airport(
            code: 'LAX',
            city: 'Los Angeles',
          ),
          arrivalAirport: Airport(
            code: 'JFK',
            city: 'New York City',
          ),
          departureTime: DateTime.now(),
          arrivalTime: DateTime.now().add(const Duration(hours: 5)),
          timestamp: DateTime(2024, 7, 30, 13),
        ),
        isNotNull,
      );
    });

    test('supports equality', () {
      final departureTime = DateTime.now();
      final arrivalTime = departureTime.add(const Duration(hours: 5));

      final flightInformation = FlightInformation(
        departureAirport: Airport(
          code: 'LAX',
          city: 'Los Angeles',
        ),
        arrivalAirport: Airport(
          code: 'JFK',
          city: 'New York City',
        ),
        departureTime: departureTime,
        arrivalTime: arrivalTime,
        timestamp: DateTime(2024, 7, 30, 13),
      );

      expect(
        flightInformation,
        equals(
          FlightInformation(
            departureAirport: Airport(
              code: 'LAX',
              city: 'Los Angeles',
            ),
            arrivalAirport: Airport(
              code: 'JFK',
              city: 'New York City',
            ),
            departureTime: departureTime,
            arrivalTime: arrivalTime,
            timestamp: DateTime(2024, 7, 30, 13),
          ),
        ),
      );
    });
  });
}
