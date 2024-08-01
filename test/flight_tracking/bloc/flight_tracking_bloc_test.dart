// ignore_for_file: prefer_const_constructors

import 'package:airplane_entertainment_system/flight_tracking/flight_tracking.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flight_information_repository/flight_information_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFlightInformationRepository extends Mock
    implements FlightInformationRepository {}

void main() {
  group('$FlightTrackingBloc', () {
    late FlightInformationRepository flightInformationRepository;

    setUp(() {
      flightInformationRepository = _MockFlightInformationRepository();
    });

    test('can be instantiated', () {
      expect(
        FlightTrackingBloc(
          flightProgressRepository: flightInformationRepository,
        ),
        isNotNull,
      );
    });

    group('FlightTrackingUpdatesRequested', () {
      blocTest<FlightTrackingBloc, FlightTrackingState>(
        'emits FlightTrackingInProgress and FlightTrackingSuccess',
        setUp: () {
          when(() => flightInformationRepository.flightInformation).thenAnswer(
            (_) => Stream.value(
              FlightInformation(
                departureAirport: Airport(city: 'New York City', code: 'JFK'),
                arrivalAirport: Airport(city: 'Nashville', code: 'BNA'),
                departureTime: DateTime(2024, 7, 30, 12),
                arrivalTime: DateTime(2024, 7, 30, 15),
                timestamp: DateTime(2024, 7, 30, 13),
              ),
            ),
          );
        },
        build: () => FlightTrackingBloc(
          flightProgressRepository: flightInformationRepository,
        ),
        act: (bloc) => bloc.add(const FlightTrackingUpdatesRequested()),
        expect: () => [
          FlightTrackingState(
            status: TrackingStatus.updating,
            flightInformation: FlightInformation(
              departureAirport: Airport(city: 'New York City', code: 'JFK'),
              arrivalAirport: Airport(city: 'Nashville', code: 'BNA'),
              departureTime: DateTime(2024, 7, 30, 12),
              arrivalTime: DateTime(2024, 7, 30, 15),
              timestamp: DateTime(2024, 7, 30, 13),
            ),
            remainingTime: const Duration(hours: 2),
            percentComplete: 33,
          ),
        ],
      );

      blocTest<FlightTrackingBloc, FlightTrackingState>(
        'emits FlightTrackingInProgress and FlightTrackingFailure',
        setUp: () {
          when(() => flightInformationRepository.flightInformation).thenAnswer(
            (_) => Stream.error(Exception('oops')),
          );
        },
        build: () => FlightTrackingBloc(
          flightProgressRepository: flightInformationRepository,
        ),
        act: (bloc) => bloc.add(const FlightTrackingUpdatesRequested()),
        expect: () => [
          FlightTrackingState(status: TrackingStatus.error),
        ],
      );

      blocTest<FlightTrackingBloc, FlightTrackingState>(
        'emits 100 for percentComplete after flight has arrived',
        setUp: () {
          when(() => flightInformationRepository.flightInformation).thenAnswer(
            (_) => Stream.value(
              FlightInformation(
                departureAirport: Airport(city: 'New York City', code: 'JFK'),
                arrivalAirport: Airport(city: 'Nashville', code: 'BNA'),
                departureTime: DateTime(2024, 7, 30, 12),
                arrivalTime: DateTime(2024, 7, 30, 15),
                timestamp: DateTime(2024, 7, 30, 18),
              ),
            ),
          );
        },
        build: () => FlightTrackingBloc(
          flightProgressRepository: flightInformationRepository,
        ),
        act: (bloc) => bloc.add(const FlightTrackingUpdatesRequested()),
        expect: () => [
          FlightTrackingState(
            status: TrackingStatus.updating,
            flightInformation: FlightInformation(
              departureAirport: Airport(city: 'New York City', code: 'JFK'),
              arrivalAirport: Airport(city: 'Nashville', code: 'BNA'),
              departureTime: DateTime(2024, 7, 30, 12),
              arrivalTime: DateTime(2024, 7, 30, 15),
              timestamp: DateTime(2024, 7, 30, 18),
            ),
            percentComplete: 100,
          ),
        ],
      );
    });
  });
}
