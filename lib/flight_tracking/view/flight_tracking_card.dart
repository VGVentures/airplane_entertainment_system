import 'package:aes_ui/aes_ui.dart';
import 'package:airplane_entertainment_system/flight_tracking/flight_tracking.dart';
import 'package:airplane_entertainment_system/l10n/l10n.dart';
import 'package:flight_information_repository/flight_information_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class FlightTrackingCard extends StatelessWidget {
  const FlightTrackingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FlightTrackingBloc(
        flightProgressRepository: context.read<FlightInformationRepository>(),
      )..add(const FlightTrackingUpdatesRequested()),
      child: const FlightTrackingCardView(),
    );
  }
}

class FlightTrackingCardView extends StatelessWidget {
  @visibleForTesting
  const FlightTrackingCardView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SizedBox(
      height: 280,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: BlocBuilder<FlightTrackingBloc, FlightTrackingState>(
            builder: (context, state) {
              if (state.status == TrackingStatus.initial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == TrackingStatus.error) {
                return Center(
                  child: Text(
                    l10n.trackingErrorMessage,
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _AirportIndicator(
                        name: state.flightInformation!.departureAirport.city,
                        code: state.flightInformation!.departureAirport.code,
                        alignment: CrossAxisAlignment.start,
                      ),
                      _AirportIndicator(
                        name: state.flightInformation!.arrivalAirport.city,
                        code: state.flightInformation!.arrivalAirport.code,
                        alignment: CrossAxisAlignment.end,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  _FlightProgress(state.percentComplete),
                  const SizedBox(
                    height: 30,
                  ),
                  _TimeIndicator(
                    departureTime: state.flightInformation!.departureTime,
                    arrivalTime: state.flightInformation!.arrivalTime,
                    remainingTime: state.remainingTime,
                  ),
                ],
              );
            },
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
    required this.remainingTime,
  });

  final DateTime departureTime;
  final DateTime arrivalTime;
  final Duration remainingTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DepartureOrArrivalTime(
          time: DateFormat('h:mm').format(departureTime),
          code: DateFormat('a').format(departureTime),
          alignment: CrossAxisAlignment.start,
        ),
        _RemainingTimeIndicator(remainingTime),
        _DepartureOrArrivalTime(
          time: DateFormat('h:mm').format(arrivalTime),
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
          style: AesTextStyles.titleLarge,
        ),
        Text(
          code,
          style: AesTextStyles.labelLarge,
        ),
      ],
    );
  }
}

class _RemainingTimeIndicator extends StatelessWidget {
  const _RemainingTimeIndicator(this.remainingTime);

  final Duration remainingTime;

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
              l10n.remainingTime(
                remainingTime.inHours,
                remainingTime.inMinutes % 60,
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        Text(
          l10n.remaining,
          style: AesTextStyles.labelLarge,
        ),
      ],
    );
  }
}

class _FlightProgress extends StatelessWidget {
  const _FlightProgress(this.progress)
      : assert(
          progress >= 0 && progress <= 100,
          'Progress must be between 0 and 100',
        );

  final int progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: progress,
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
          flex: 100 - progress,
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
