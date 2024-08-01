part of 'flight_tracking_bloc.dart';

enum TrackingStatus {
  initial,
  updating,
  error,
}

class FlightTrackingState extends Equatable {
  const FlightTrackingState({
    this.status = TrackingStatus.initial,
    this.flightInformation,
    this.remainingTime = Duration.zero,
    this.percentComplete = 0,
  });

  final TrackingStatus status;

  final FlightInformation? flightInformation;

  final Duration remainingTime;

  final int percentComplete;

  FlightTrackingState copyWith({
    TrackingStatus? status,
    FlightInformation? flightInformation,
    Duration? remainingTime,
    int? percentComplete,
  }) {
    return FlightTrackingState(
      status: status ?? this.status,
      flightInformation: flightInformation ?? this.flightInformation,
      remainingTime: remainingTime ?? this.remainingTime,
      percentComplete: percentComplete ?? this.percentComplete,
    );
  }

  @override
  List<Object?> get props => [
        status,
        flightInformation,
        remainingTime,
        percentComplete,
      ];
}
