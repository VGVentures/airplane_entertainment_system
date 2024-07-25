import 'package:flutter/widgets.dart';

/// {@template aes_layout}
/// Describes the layout of the current window.
/// {@endtemplate}
enum AesLayoutData {
  /// A small layout.
  ///
  /// Typically used for mobile devices.
  small,

  /// A large layout.
  ///
  /// Typically used for tablets and desktops.
  large;

  /// Derives the layout from the given [windowSize].
  static AesLayoutData _derive(Size windowSize) {
    return windowSize.width < windowSize.height ||
            windowSize.width < AesLayout.mobileBreakpoint
        ? AesLayoutData.small
        : AesLayoutData.large;
  }
}

/// {@template aes_layout}
/// Derives and provides [AesLayoutData] to its descendants.
///
/// See also:
///
/// * [AesLayout.of], a static method which retrieves the
///   closest [AesLayoutData].
/// * [AesLayoutData], an enum which describes the layout of the current window.
/// {@endtemplate}
class AesLayout extends StatelessWidget {
  /// {@macro aes_layout}
  const AesLayout({
    required this.child,
    this.data,
    super.key,
  });

  /// The threshold width at which the layout should change.
  static const double mobileBreakpoint = 600;

  /// The layout to provide to the child.
  ///
  /// If `null` it is derived from the current size of the window. Otherwise,
  /// it will be fixed to the provided value.
  final AesLayoutData? data;

  /// The child widget which will have access to the current [AesLayoutData].
  final Widget child;

  /// Retrieves the closest [_AesLayoutScope] from the given [context].
  static AesLayoutData of(BuildContext context) {
    final layout =
        context.dependOnInheritedWidgetOfExactType<_AesLayoutScope>();
    assert(layout != null, 'No AesLayout found in context');
    return layout!.layout;
  }

  @override
  Widget build(BuildContext context) {
    return _AesLayoutScope(
      layout: data ?? AesLayoutData._derive(MediaQuery.sizeOf(context)),
      child: child,
    );
  }
}

/// {@template aes_layout_scope}
/// A widget which provides the current [AesLayoutData] to its descendants.
/// {@endtemplate}
class _AesLayoutScope extends InheritedWidget {
  /// {@macro aes_layout_scope}
  const _AesLayoutScope({
    required super.child,
    required this.layout,
  });

  /// {@macro aes_layout_data}
  final AesLayoutData layout;

  @override
  bool updateShouldNotify(covariant _AesLayoutScope oldWidget) {
    return layout != oldWidget.layout;
  }
}
