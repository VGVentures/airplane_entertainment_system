import 'package:equatable/equatable.dart';

/// {@template airport}
/// A model representing an airport.
/// {@endtemplate}
class Airport extends Equatable {
  /// {@macro airport}
  const Airport({
    required this.city,
    required this.code,
  });

  /// The airport's city.
  final String city;

  /// The airport's code.
  final String code;

  @override
  List<Object> get props => [
        city,
        code,
      ];
}
