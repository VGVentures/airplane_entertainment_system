import 'package:flutter/material.dart';

/// {@template destination}
/// A model representing a destination in the app.
/// {@endtemplate}
class Destination {
  /// {@macro destination}
  const Destination(
    this.widget,
    this.label,
  );

  /// The widget to display for this destination.
  final Widget widget;

  /// The label to display for this destination.
  final String label;
}
