// ignore_for_file: prefer_const_constructors

import 'package:airplane_entertainment_system/flight_tracking/flight_tracking.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flight_information_repository/flight_information_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockFlightTrackingBloc
    extends MockBloc<FlightTrackingEvent, FlightTrackingState>
    implements FlightTrackingBloc {}

void main() {
  group('$FlightTrackingCard', () {
    testWidgets('renders flight tracking card', (tester) async {
      await tester.pumpApp(const FlightTrackingCard());

      expect(find.byType(FlightTrackingCard), findsOneWidget);
    });

    testWidgets('renders CircularProgressIndicator when initial state',
        (tester) async {
      final FlightTrackingBloc flightTrackingBloc = _MockFlightTrackingBloc();
      when(() => flightTrackingBloc.state)
          .thenReturn(const FlightTrackingState());

      await tester.pumpApp(
        BlocProvider.value(
          value: flightTrackingBloc,
          child: FlightTrackingCardView(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders flight information when status is updating',
        (tester) async {
      final FlightTrackingBloc flightTrackingBloc = _MockFlightTrackingBloc();
      when(() => flightTrackingBloc.state).thenReturn(
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
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: flightTrackingBloc,
          child: FlightTrackingCardView(),
        ),
      );

      expect(find.text('New York City'), findsOneWidget);
      expect(find.text('JFK'), findsOneWidget);
      expect(find.text('Nashville'), findsOneWidget);
      expect(find.text('BNA'), findsOneWidget);
      expect(find.text('12:00'), findsOneWidget);
      expect(find.text('3:00'), findsOneWidget);
      expect(find.text(tester.l10n.remainingTime(2, 0)), findsOneWidget);
    });

    testWidgets('renders error message when status is error', (tester) async {
      final FlightTrackingBloc flightTrackingBloc = _MockFlightTrackingBloc();
      when(() => flightTrackingBloc.state).thenReturn(
        FlightTrackingState(status: TrackingStatus.error),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: flightTrackingBloc,
          child: FlightTrackingCardView(),
        ),
      );

      expect(find.text(tester.l10n.trackingErrorMessage), findsOneWidget);
    });
  });
}
