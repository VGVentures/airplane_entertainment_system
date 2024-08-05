import 'package:aes_ui/aes_ui.dart';
import 'package:airplane_entertainment_system/airplane_entertainment_system/airplane_entertainment_system.dart';
import 'package:airplane_entertainment_system/l10n/l10n.dart';
import 'package:airplane_entertainment_system/music_player/music_player.dart';
import 'package:airplane_entertainment_system/weather/weather.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AirplaneEntertainmentSystemScreen extends StatelessWidget {
  const AirplaneEntertainmentSystemScreen({
    required this.navigationShell,
    required this.children,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WeatherBloc(
            weatherRepository: context.read(),
          )..add(const WeatherUpdatesRequested()),
        ),
        BlocProvider(
          create: (context) => MusicPlayerCubit(
            musicRepository: context.read(),
            player: context.read(),
          )..initialize(),
        ),
      ],
      child: AirplaneEntertainmentSystemView(
        navigationShell,
        children,
      ),
    );
  }
}

class AirplaneEntertainmentSystemView extends StatelessWidget {
  const AirplaneEntertainmentSystemView(
    this.navigationShell,
    this.children, {
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final layout = AesLayout.of(context);
    final l10n = context.l10n;

    final destinations = <Destination>[
      Destination(
        const Icon(Icons.airplanemode_active_outlined),
        l10n.overviewLabel,
      ),
      Destination(
        const Icon(Icons.music_note),
        l10n.musicLabel,
      ),
    ];

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Positioned.fill(
                child: SystemBackground(
                  page: navigationShell.currentIndex,
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
                              selectedIndex: navigationShell.currentIndex,
                              onDestinationSelected: (index) {
                                navigationShell.goBranch(
                                  index,
                                  initialLocation:
                                      index == navigationShell.currentIndex,
                                );
                              },
                            ),
                          Expanded(
                            child: _AnimatedBranchContainer(
                              currentIndex: navigationShell.currentIndex,
                              children: children,
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
                      opacity: navigationShell.currentIndex == 0 ? 0.8 : 0,
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
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (index) {
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
            )
          : null,
    );
  }
}

class _AnimatedBranchContainer extends StatelessWidget {
  const _AnimatedBranchContainer({
    required this.currentIndex,
    required this.children,
  });

  final int currentIndex;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: children.mapIndexed(
        (int index, Widget navigator) {
          return AnimatedOpacity(
            opacity: index == currentIndex ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: IgnorePointer(
              ignoring: index != currentIndex,
              child: TickerMode(
                enabled: index == currentIndex,
                child: navigator,
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
