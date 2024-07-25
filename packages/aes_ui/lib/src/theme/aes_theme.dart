import 'package:flutter/material.dart';

/// {@template aes_theme}
/// Airplane Entertainment System theme.
/// {@endtemplate}
class AesTheme {
  /// {@macro aes_theme}
  const AesTheme();

  /// [ThemeData] for the Airplane Entertainment System.
  ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      navigationRailTheme: const NavigationRailThemeData(
        labelType: NavigationRailLabelType.none,
        selectedIconTheme: IconThemeData(size: 36, color: Colors.red),
        unselectedIconTheme: IconThemeData(size: 36, color: Colors.black),
        groupAlignment: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>(
          (Set<WidgetState> states) => states.contains(WidgetState.selected)
              ? const IconThemeData(color: Colors.red)
              : const IconThemeData(color: Colors.black),
        ),
      ),
    );
  }
}
