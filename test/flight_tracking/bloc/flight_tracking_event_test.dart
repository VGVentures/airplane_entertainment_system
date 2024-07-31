// ignore_for_file: prefer_const_constructors

import 'package:airplane_entertainment_system/flight_tracking/flight_tracking.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('$FlightTrackingEvent', () {
    group('FlightTrackingUpdatedRequested', () {
      test('supports value comparisons', () {
        expect(
          FlightTrackingUpdatesRequested(),
          equals(FlightTrackingUpdatesRequested()),
        );
      });
    });
  });
}
