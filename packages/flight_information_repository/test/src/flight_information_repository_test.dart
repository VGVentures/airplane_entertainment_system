// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:flight_api_client/flight_api_client.dart';
import 'package:flight_information_repository/src/flight_information_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockFlightApiClient extends Mock implements FlightApiClient {}

void main() {
  group('$FlightInformationRepository', () {
    late FlightApiClient flightApiClient;

    setUp(() {
      flightApiClient = _MockFlightApiClient();
    });

    test('can be instantiated', () {
      expect(FlightInformationRepository(flightApiClient), isNotNull);
    });

    group('flightInformation', () {
      test('emits FlightInformation updates', () {
        final repository = FlightInformationRepository(flightApiClient);
        final controller = StreamController<FlightInformation>();
        final updates = <FlightInformation>[];

        when(() => flightApiClient.flightInformation).thenAnswer(
          (_) => controller.stream,
        );

        controller.add(
          FlightInformation(
            departureAirport: Airport(city: 'New York City', code: 'JFK'),
            arrivalAirport: Airport(city: 'Nashville', code: 'BNA'),
            departureTime: DateTime(2024),
            arrivalTime: DateTime(2024),
            timestamp: DateTime(2024, 7, 30),
          ),
        );

        repository.flightInformation.listen(updates.add);

        expect(
          repository.flightInformation,
          emits(
            isA<FlightInformation>().having(
              (flightInformation) => flightInformation.timestamp,
              'timestamp',
              equals(DateTime(2024, 7, 30)),
            ),
          ),
        );
      });
    });
  });
}
