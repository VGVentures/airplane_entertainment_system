import 'package:airplane_entertainment_system/demo/demo.dart';
import 'package:airplane_entertainment_system/music_player/music_player.dart';
import 'package:airplane_entertainment_system/overview/overview.dart';
import 'package:flutter/material.dart';

class AirplaneEntertainmentSystemDemo extends StatefulWidget {
  const AirplaneEntertainmentSystemDemo({super.key});

  @override
  State<AirplaneEntertainmentSystemDemo> createState() =>
      _AirplaneEntertainmentSystemDemoState();
}

class _AirplaneEntertainmentSystemDemoState
    extends State<AirplaneEntertainmentSystemDemo> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned.fill(
                child: DemoBackground(
                  page: _currentPage,
                ),
              ),
              Column(
                children: [
                  const TopButtonBar(),
                  Expanded(
                    child: Row(
                      children: [
                        LeftSideNavigationRail(
                          selectedIndex: _currentPage,
                          onOptionSelected: (value) {
                            setState(() {
                              _currentPage = value;
                            });
                          },
                        ),
                        Expanded(
                          child: _DemoPageView(
                            pageSize: Size(
                              constraints.maxWidth,
                              constraints.maxHeight,
                            ),
                            pageIndex: _currentPage,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Display clouds over the airplane only on the first screen.
              Positioned.fill(
                left: 80,
                right: constraints.maxWidth * 0.4,
                child: IgnorePointer(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 600),
                    opacity: _currentPage == 0 ? 0.8 : 0,
                    child: const Clouds(
                      key: Key('foregroundClouds'),
                      count: 3,
                      averageScale: 0.25,
                      averageVelocity: 2,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DemoPageView extends StatefulWidget {
  const _DemoPageView({
    required this.pageSize,
    required this.pageIndex,
  });

  final Size pageSize;
  final int pageIndex;

  @override
  State<_DemoPageView> createState() => _DemoPageViewState();
}

class _DemoPageViewState extends State<_DemoPageView>
    with SingleTickerProviderStateMixin {
  static const _placeholderPage = Center(
    child: SizedBox.square(
      dimension: 400,
      child: Placeholder(),
    ),
  );
  static const _pages = [
    OverviewPage(key: Key('overviewPage')),
    MusicPlayerPage(key: Key('musicPlayerPage')),
    _placeholderPage,
    _placeholderPage,
    _placeholderPage,
    _placeholderPage,
  ];

  late final AnimationController _controller = AnimationController(
    vsync: this,
    value: 1,
    duration: const Duration(milliseconds: 600),
  );
  late int _previousPage;
  late int _currentPage;

  @override
  void initState() {
    super.initState();

    _previousPage = widget.pageIndex;
    _currentPage = widget.pageIndex;

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _previousPage = _currentPage;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant _DemoPageView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.pageIndex != oldWidget.pageIndex) {
      setState(() {
        _previousPage = oldWidget.pageIndex;
        _currentPage = widget.pageIndex;
      });
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageOffset = widget.pageSize.height / 4;

    return Stack(
      children: [
        if (_previousPage != _currentPage)
          _PositionedFadeTransition(
            positionAnimation: _controller.drive(
              CurveTween(
                curve: Curves.easeInOut,
              ),
            ),
            opacityAnimation: _controller.drive(
              Tween<double>(begin: 1, end: 0).chain(
                CurveTween(
                  curve: const Interval(
                    0,
                    0.5,
                    curve: Curves.easeOut,
                  ),
                ),
              ),
            ),
            pageSize: widget.pageSize,
            endOffset: _currentPage > _previousPage ? -pageOffset : pageOffset,
            child: _pages[_previousPage],
          ),
        _PositionedFadeTransition(
          positionAnimation: _controller.drive(
            CurveTween(
              curve: Curves.easeInOut,
            ),
          ),
          opacityAnimation: _controller.drive(
            CurveTween(
              curve: const Interval(
                0.5,
                1,
                curve: Curves.easeIn,
              ),
            ),
          ),
          pageSize: widget.pageSize,
          beginOffset: _currentPage > _previousPage ? pageOffset : -pageOffset,
          child: _pages[_currentPage],
        ),
      ],
    );
  }
}

class _PositionedFadeTransition extends StatelessWidget {
  const _PositionedFadeTransition({
    required this.positionAnimation,
    required this.opacityAnimation,
    required this.pageSize,
    required this.child,
    this.beginOffset = 0,
    this.endOffset = 0,
  });

  final Animation<double> positionAnimation;
  final Animation<double> opacityAnimation;
  final Size pageSize;
  final Widget child;
  final double beginOffset;
  final double endOffset;

  @override
  Widget build(BuildContext context) {
    return PositionedTransition(
      rect: positionAnimation.drive(
        RelativeRectTween(
          begin: RelativeRect.fromLTRB(0, beginOffset, 0, -beginOffset),
          end: RelativeRect.fromLTRB(0, endOffset, 0, -endOffset),
        ),
      ),
      child: FadeTransition(
        key: ValueKey<Key?>(child.key),
        opacity: opacityAnimation,
        child: SizedBox.fromSize(
          size: pageSize,
          child: child,
        ),
      ),
    );
  }
}
