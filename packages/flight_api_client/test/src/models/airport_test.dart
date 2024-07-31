// ignore_for_file: prefer_const_constructors

import 'package:flight_api_client/flight_api_client.dart';
import 'package:test/test.dart';

void main() {
  group('$Airport', () {
    test('can be instantiated', () {
      expect(
        Airport(
          code: 'LAX',
          city: 'Los Angeles',
        ),
        isNotNull,
      );
    });

    test('supports equality', () {
      final airport = Airport(
        code: 'LAX',
        city: 'Los Angeles',
      );

      expect(
        airport,
        equals(
          Airport(
            code: 'LAX',
            city: 'Los Angeles',
          ),
        ),
      );
    });
  });
}
