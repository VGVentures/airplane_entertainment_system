import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flight_information_repository/flight_information_repository.dart';

part 'flight_tracking_event.dart';
part 'flight_tracking_state.dart';

class FlightTrackingBloc
    extends Bloc<FlightTrackingEvent, FlightTrackingState> {
  FlightTrackingBloc({
    required FlightInformationRepository flightProgressRepository,
  })  : _flightInformationRepository = flightProgressRepository,
        super(const FlightTrackingState()) {
    on<FlightTrackingUpdatesRequested>(_onFlightTrackingUpdatesRequested);
  }

  final FlightInformationRepository _flightInformationRepository;

  Future<void> _onFlightTrackingUpdatesRequested(
    FlightTrackingUpdatesRequested event,
    Emitter<FlightTrackingState> emit,
  ) async {
    await emit.forEach(
      _flightInformationRepository.flightInformation,
      onData: (flightInformation) {
        final remainingTime =
            flightInformation.timestamp.isAfter(flightInformation.arrivalTime)
                ? Duration.zero
                : flightInformation.arrivalTime
                    .difference(flightInformation.timestamp);

        final percentComplete = (100 -
                remainingTime.inMinutes /
                    flightInformation.arrivalTime
                        .difference(flightInformation.departureTime)
                        .inMinutes *
                    100)
            .toInt();

        return state.copyWith(
          status: TrackingStatus.updating,
          flightInformation: flightInformation,
          remainingTime: remainingTime,
          percentComplete: percentComplete,
        );
      },
      onError: (error, stackTrace) {
        return state.copyWith(status: TrackingStatus.error);
      },
    );
  }
}
