import 'package:aes_ui/aes_ui.dart';
import 'package:airplane_entertainment_system/l10n/l10n.dart';
import 'package:flight_information_repository/flight_information_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFlightRepository extends Mock
    implements FlightInformationRepository {
  @override
  Stream<FlightInformation> get flightInformation => const Stream.empty();
}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    FlightInformationRepository? flightInformationRepository,
    AesLayoutData? layout,
  }) async {
    if (layout == AesLayoutData.large) {
      await binding.setSurfaceSize(const Size(1600, 1200));
      addTearDown(() => binding.setSurfaceSize(null));
    }

    return pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<FlightInformationRepository>(
            create: (_) =>
                flightInformationRepository ?? _MockFlightRepository(),
          ),
        ],
        child: AesLayout(
          data: layout,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: widget,
          ),
        ),
      ),
    );
  }
}
