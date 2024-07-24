import 'package:airplane_entertainment_system/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FlightTrackingCard extends StatelessWidget {
  const FlightTrackingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _AirportIndicator(
                    name: 'San Francisco',
                    code: 'SFO',
                    alignment: CrossAxisAlignment.start,
                  ),
                  _AirportIndicator(
                    name: 'New York City',
                    code: 'NYC',
                    alignment: CrossAxisAlignment.end,
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const _FlightProgress(),
              const SizedBox(
                height: 30,
              ),
              _TimeIndicator(
                departureTime: DateTime.now(),
                arrivalTime: DateTime.now().add(const Duration(hours: 2)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AirportIndicator extends StatelessWidget {
  const _AirportIndicator({
    required this.name,
    required this.code,
    required this.alignment,
  });

  final String name;
  final String code;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          code,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _TimeIndicator extends StatelessWidget {
  const _TimeIndicator({
    required this.departureTime,
    required this.arrivalTime,
  });

  final DateTime departureTime;
  final DateTime arrivalTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DepartureOrArrivalTime(
          time: DateFormat('hh:mm').format(departureTime),
          code: DateFormat('a').format(departureTime),
          alignment: CrossAxisAlignment.start,
        ),
        const _RemainingTimeIndicator(),
        _DepartureOrArrivalTime(
          time: DateFormat('hh:mm').format(arrivalTime),
          code: DateFormat('a').format(arrivalTime),
          alignment: CrossAxisAlignment.end,
        ),
      ],
    );
  }
}

class _DepartureOrArrivalTime extends StatelessWidget {
  const _DepartureOrArrivalTime({
    required this.time,
    required this.code,
    required this.alignment,
  });

  final String time;
  final String code;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          time,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          code,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _RemainingTimeIndicator extends StatelessWidget {
  const _RemainingTimeIndicator();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '2 ${l10n.hours}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        Text(
          l10n.remaining,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _FlightProgress extends StatelessWidget {
  const _FlightProgress();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 11,
          child: SizedBox(
            height: 5,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.red,
              ),
            ),
          ),
        ),
        Transform.rotate(
          angle: 3.14 / 2,
          child: const Icon(
            Icons.airplanemode_active,
            color: Colors.red,
            size: 32,
          ),
        ),
        Expanded(
          flex: 8,
          child: SizedBox(
            height: 5,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
