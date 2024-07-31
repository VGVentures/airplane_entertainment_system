// ignore_for_file: prefer_const_constructors
import 'package:flight_api_client/flight_api_client.dart';
import 'package:test/test.dart';

void main() {
  group('$FlightApiClient', () {
    test('can be instantiated', () {
      expect(FlightApiClient(), isNotNull);
    });

    group('flightInformation', () {
      test('emits FlightInformation updates', () {
        final client = FlightApiClient();

        expect(
          client.flightInformation,
          emitsInOrder([
            isA<FlightInformation>(),
          ]),
        );
      });
    });

    group('dispose', () {
      test('closes the flightInformation stream', () async {
        final client = FlightApiClient();
        final updates = <FlightInformation>[];

        client.flightInformation.listen(updates.add);

        await client.dispose();

        expect(updates.length, equals(1));
      });
    });
  });
}
