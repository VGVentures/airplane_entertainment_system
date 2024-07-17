import 'package:flutter/material.dart';

class LeftSideNavigationRail extends StatelessWidget {
  const LeftSideNavigationRail({
    required this.selectedIndex,
    super.key,
    this.onOptionSelected,
  });

  final int selectedIndex;
  final ValueChanged<int>? onOptionSelected;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomRectangularShape(),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 80, maxHeight: 550),
        child: Theme(
          data: ThemeData(
            navigationRailTheme: const NavigationRailThemeData(
              labelType: NavigationRailLabelType.none,
              selectedIconTheme: IconThemeData(size: 36, color: Colors.red),
              unselectedIconTheme: IconThemeData(size: 36),
              groupAlignment: 0,
            ),
          ),
          child: Center(
            child: NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: onOptionSelected,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.airplanemode_active),
                  label: Text('airplanemode_active'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.headphones),
                  label: Text('headphones'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.play_arrow),
                  label: Text('play_arrow'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.face),
                  label: Text('face'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.shopping_bag_outlined),
                  label: Text('shopping_bag_outlined'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  label: Text('settings'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

@visibleForTesting
class CustomRectangularShape extends CustomClipper<Path> {
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

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
