part of 'flight_tracking_bloc.dart';

class FlightTrackingEvent extends Equatable {
  const FlightTrackingEvent();

  @override
  List<Object?> get props => [];
}

class FlightTrackingUpdatesRequested extends FlightTrackingEvent {
  const FlightTrackingUpdatesRequested();
}
