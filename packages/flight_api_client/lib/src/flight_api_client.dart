import 'dart:async';
import 'dart:math';

import 'package:flight_api_client/flight_api_client.dart';

/// {@template flight_api_client}
/// The flight API client.
///
/// This is a mock API client that simulates fetching flight information from a
/// server. The stream emits a new [FlightInformation] object every minute for
/// a mock flight from Newark to New York City.
/// {@endtemplate}
class FlightApiClient {
  /// {@macro flight_api_client}
  FlightApiClient();

  final StreamController<FlightInformation> _controller =
      StreamController<FlightInformation>();

  Timer? _timer;

  final DateTime _timestamp = DateTime(2024, 7, 30, 13);

  static const _updateInterval = Duration(minutes: 1);

  /// Retrieves the flight information.
  ///
  /// Flight information is added to the stream when called and every minute
  /// after that until the client is disposed. If ths were a real API client,
  /// the data would be fetched from a server and the arrival time and
  /// destination airport could update based on the flight's progress.
  Stream<FlightInformation> get flightInformation {
    _controller.add(_generateTestData());

    _timer ??= Timer.periodic(_updateInterval, (timer) {
      _controller.add(_generateTestData());
    });

    return _controller.stream;
  }

  FlightInformation _generateTestData() {
    // Randomize the arrival time to simulate a possible delay, such as
    // weather or traffic.
    final random = Random();

    final departureTime = DateTime(2024, 7, 30, 13);
    final arrivalTime = departureTime.add(
      Duration(minutes: random.nextInt(3) + 45),
    );

    return FlightInformation(
      departureAirport: const Airport(
        city: 'Newark',
        code: 'EWR',
      ),
      arrivalAirport: const Airport(
        city: 'New York City',
        code: 'LGA',
      ),
      departureTime: departureTime,
      arrivalTime: arrivalTime,
      timestamp: _timestamp.add(_updateInterval),
    );
  }

  /// Cancels the timer and closes the stream controller.
  Future<void> dispose() async {
    _timer?.cancel();
    await _controller.close();
  }
}
