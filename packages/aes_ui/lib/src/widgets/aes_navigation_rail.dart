import 'package:aes_ui/aes_ui.dart';
import 'package:flutter/material.dart';

/// {@template aes_navigation_rail}
/// A navigation rail for the Airplane Entertainment System.
/// {@endtemplate}
class AesNavigationRail extends StatelessWidget {
  /// {@macro aes_navigation_rail}
  const AesNavigationRail({
    required this.destinations,
    required this.selectedIndex,
    this.onDestinationSelected,
    super.key,
  });

  /// The destinations to display in the navigation rail.
  final List<Destination> destinations;

  /// The index of the selected destination.
  final int selectedIndex;

  /// A callback that is called when a destination is selected.
  final ValueChanged<int>? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: const _CustomRectangularShape(),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 80, maxHeight: 550),
        child: Center(
          child: NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            destinations: destinations.map((destination) {
              return NavigationRailDestination(
                icon: destination.widget,
                label: Text(destination.label),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _CustomRectangularShape extends CustomClipper<Path> {
  const _CustomRectangularShape();

  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(size.width - 10, 50)
      ..quadraticBezierTo(size.width, 55, size.width, 70)
      ..lineTo(size.width, size.height - 70)
      ..quadraticBezierTo(
        size.width,
        size.height - 55,
        size.width - 10,
        size.height - 50,
      )
      ..lineTo(0, size.height);

    return path;
  }

  // coverage:ignore-start
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
  // coverage:ignore-end
}
