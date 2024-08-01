// ignore_for_file: prefer_const_constructors
import 'package:fake_async/fake_async.dart';
import 'package:flight_api_client/flight_api_client.dart';
import 'package:test/test.dart';

void main() {
  group('$FlightApiClient', () {
    test('can be instantiated', () {
      expect(FlightApiClient(), isNotNull);
    });

    group('flightInformation', () {
      test('emits FlightInformation updates', () {
        fakeAsync((async) {
          final client = FlightApiClient();
          final updates = <FlightInformation>[];

          client.flightInformation.listen(updates.add);

          async.elapse(Duration(minutes: 1));

          expect(updates.length, equals(2));

          async.elapse(Duration(minutes: 1));

          expect(updates.length, equals(3));
        });
      });

      test('stops emitting updates after the arrival time', () {
        fakeAsync((async) {
          final client = FlightApiClient();
          final updates = <FlightInformation>[];

          client.flightInformation.listen(updates.add);

          // Within 50 minutes, there shouldn't be more than 48 updates.
          async.elapse(Duration(minutes: 50));

          final numberOfUpdates = updates.length;

          // Flight has arrived by this point, so no more updates
          // should be emitted.
          async.elapse(Duration(minutes: 5));

          expect(updates.length, equals(numberOfUpdates));
        });
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
