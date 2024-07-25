import 'package:flutter/material.dart';

/// {@template aes_text_styles}
/// A collection of [TextStyle] objects used in the
/// Airplane Entertainment System.
/// {@endtemplate}
class AesTextStyles {
  /// Large headline text style.
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 80,
    fontWeight: FontWeight.w600,
    height: 1,
  );

  /// Large title text style.
  static const TextStyle titleLarge = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  /// Large label text style.
  static const TextStyle labelLarge = TextStyle(
    color: Colors.grey,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
}
