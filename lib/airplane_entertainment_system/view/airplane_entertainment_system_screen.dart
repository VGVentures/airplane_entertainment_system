import 'package:aes_ui/aes_ui.dart';
import 'package:airplane_entertainment_system/airplane_entertainment_system/airplane_entertainment_system.dart';
import 'package:airplane_entertainment_system/music_player/music_player.dart';
import 'package:airplane_entertainment_system/overview/overview.dart';
import 'package:airplane_entertainment_system/weather/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AirplaneEntertainmentSystemScreen extends StatelessWidget {
  const AirplaneEntertainmentSystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherBloc(weatherRepository: context.read())
        ..add(const WeatherUpdatesRequested()),
      child: const AirplaneEntertainmentSystemView(),
    );
  }
}

class AirplaneEntertainmentSystemView extends StatefulWidget {
  const AirplaneEntertainmentSystemView({super.key});

  @override
  State<AirplaneEntertainmentSystemView> createState() =>
      _AirplaneEntertainmentSystemViewState();
}

class _AirplaneEntertainmentSystemViewState
    extends State<AirplaneEntertainmentSystemView> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final layout = AesLayout.of(context);

    const destinations = <Destination>[
      Destination(
        Icon(Icons.airplanemode_active_outlined),
        'Home',
      ),
      Destination(
        Icon(Icons.music_note),
        'Music',
      ),
    ];

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned.fill(
                child: SystemBackground(
                  page: _currentPage,
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    const TopButtonBar(),
                    Expanded(
                      child: Row(
                        children: [
                          if (layout != AesLayoutData.small)
                            AesNavigationRail(
                              destinations: destinations,
                              selectedIndex: _currentPage,
                              onDestinationSelected: (value) {
                                setState(() {
                                  _currentPage = value;
                                });
                              },
                            ),
                          Expanded(
                            child: _ContentPageView(
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
              ),
              // Display clouds over the airplane only on the first screen.
              if (layout == AesLayoutData.large)
                Positioned.fill(
                  left: 80,
                  right: constraints.maxWidth * 0.4,
                  child: IgnorePointer(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 600),
                      opacity: _currentPage == 0 ? 0.8 : 0,
                      child: const WeatherClouds(
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
      bottomNavigationBar: (layout == AesLayoutData.small)
          ? AesBottomNavigationBar(
              destinations: destinations,
              selectedIndex: _currentPage,
              onDestinationSelected: (value) {
                setState(() {
                  _currentPage = value;
                });
              },
            )
          : null,
    );
  }
}

class _ContentPageView extends StatefulWidget {
  const _ContentPageView({
    required this.pageSize,
    required this.pageIndex,
  });

  final Size pageSize;
  final int pageIndex;

  @override
  State<_ContentPageView> createState() => _ContentPageViewState();
}

class _ContentPageViewState extends State<_ContentPageView>
    with SingleTickerProviderStateMixin {
  static const _pages = [
    OverviewPage(key: Key('overviewPage')),
    MusicPlayerPage(key: Key('musicPlayerPage')),
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
  void didUpdateWidget(covariant _ContentPageView oldWidget) {
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
    final isSmall = AesLayout.of(context) == AesLayoutData.small;
    final pageSize = widget.pageSize;
    final pageSide = isSmall ? pageSize.width : pageSize.width.hashCode;
    final pageOffset = pageSide / 4;
    final axis = isSmall ? Axis.horizontal : Axis.vertical;

    return Stack(
      children: [
        if (_previousPage != _currentPage)
          _PositionedFadeTransition(
            axis: axis,
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
          axis: axis,
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
    required this.axis,
    this.beginOffset = 0,
    this.endOffset = 0,
  });

  final Animation<double> positionAnimation;
  final Animation<double> opacityAnimation;
  final Size pageSize;
  final Widget child;
  final double beginOffset;
  final double endOffset;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final begin = axis == Axis.horizontal
        ? RelativeRect.fromLTRB(beginOffset, 0, -beginOffset, 0)
        : RelativeRect.fromLTRB(0, beginOffset, 0, -beginOffset);

    final end = axis == Axis.horizontal
        ? RelativeRect.fromLTRB(endOffset, 0, -endOffset, 0)
        : RelativeRect.fromLTRB(0, endOffset, 0, -endOffset);

    return PositionedTransition(
      rect: positionAnimation.drive(
        RelativeRectTween(begin: begin, end: end),
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
