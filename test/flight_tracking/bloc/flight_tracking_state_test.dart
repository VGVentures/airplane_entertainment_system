// ignore_for_file: prefer_const_constructors

import 'package:airplane_entertainment_system/flight_tracking/flight_tracking.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('$FlightTrackingState', () {
    test('supports value comparisons', () {
      expect(FlightTrackingState(), equals(FlightTrackingState()));
    });

    group('copyWith', () {
      test('returns same object when no properties are passed', () {
        expect(FlightTrackingState().copyWith(), equals(FlightTrackingState()));
      });
    });
  });
}
