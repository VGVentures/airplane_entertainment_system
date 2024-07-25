import 'package:aes_ui/aes_ui.dart';
import 'package:flutter/material.dart';

/// {@template aes_bottom_navigation_bar}
/// A custom bottom navigation bar for the Airplane Entertainment System.
/// {@endtemplate}
class AesBottomNavigationBar extends StatelessWidget {
  /// {@macro aes_bottom_navigation_bar}
  const AesBottomNavigationBar({
    required this.destinations,
    required this.selectedIndex,
    this.onDestinationSelected,
    super.key,
  });

  /// The destinations to display in the bottom navigation bar.
  final List<Destination> destinations;

  /// The index of the selected destination.
  final int selectedIndex;

  /// A callback that is called when a destination is selected.
  final ValueChanged<int>? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: destinations.map((destination) {
        return NavigationDestination(
          icon: destination.widget,
          label: destination.label,
        );
      }).toList(),
    );
  }
}
