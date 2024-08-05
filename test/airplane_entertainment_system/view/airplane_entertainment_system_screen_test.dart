import 'package:aes_ui/aes_ui.dart';
import 'package:airplane_entertainment_system/airplane_entertainment_system/airplane_entertainment_system.dart';
import 'package:airplane_entertainment_system/music_player/music_player.dart';
import 'package:airplane_entertainment_system/overview/overview.dart';
import 'package:airplane_entertainment_system/weather/weather.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_repository/music_repository.dart';
import 'package:weather_repository/weather_repository.dart';

import '../../helpers/helpers.dart';

class _MockAudioCache extends Mock implements AudioCache {}

class _MockAudioPlayer extends Mock implements AudioPlayer {}

class _MockStatefulNavigationShell extends Mock
    implements StatefulNavigationShell {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return '';
  }
}

class _MockWeatherBloc extends MockBloc<WeatherEvent, WeatherState>
    implements WeatherBloc {}

class _MockMusicPlayerCubit extends MockCubit<MusicPlayerState>
    implements MusicPlayerCubit {}

void main() {
  group('$AirplaneEntertainmentSystemScreen', () {
    late WeatherRepository weatherRepository;
    late MusicRepository musicRepository;
    late AudioPlayer audioPlayer;
    late StatefulNavigationShell navigationShell;

    setUp(() {
      weatherRepository = MockWeatherRepository();
      when(() => weatherRepository.weatherInformation)
          .thenAnswer((_) => const Stream.empty());

      musicRepository = MockMusicRepository();
      when(musicRepository.getTracks).thenReturn(const []);

      audioPlayer = _MockAudioPlayer();
      when(() => audioPlayer.onPositionChanged)
          .thenAnswer((_) => const Stream.empty());
      when(() => audioPlayer.onPlayerStateChanged)
          .thenAnswer((_) => const Stream.empty());
      when(audioPlayer.release).thenAnswer((_) async {});

      final audioCache = _MockAudioCache();
      when(() => audioPlayer.audioCache).thenReturn(audioCache);
      when(() => audioPlayer.setVolume(any())).thenAnswer((_) async {});

      navigationShell = _MockStatefulNavigationShell();

      when(
        () => navigationShell.goBranch(
          any(),
          initialLocation: any(named: 'initialLocation'),
        ),
      ).thenAnswer((_) => {});
      when(() => navigationShell.currentIndex).thenReturn(0);
    });

    testWidgets('finds one $AirplaneEntertainmentSystemView Widget',
        (tester) async {
      await tester.pumpApp(
        AirplaneEntertainmentSystemScreen(
          navigationShell: navigationShell,
          children: const [
            OverviewPage(),
            MusicPlayerPage(),
          ],
        ),
        layout: AesLayoutData.small,
        musicRepository: musicRepository,
        weatherRepository: weatherRepository,
        audioPlayer: audioPlayer,
      );

      expect(find.byType(AirplaneEntertainmentSystemView), findsOneWidget);
    });
  });

  group('$AirplaneEntertainmentSystemView', () {
    late StatefulNavigationShell navigationShell;

    setUp(() {
      navigationShell = _MockStatefulNavigationShell();

      when(
        () => navigationShell.goBranch(
          any(),
          initialLocation: any(named: 'initialLocation'),
        ),
      ).thenAnswer((_) => {});
      when(() => navigationShell.currentIndex).thenReturn(0);
    });

    testWidgets('shows $AesNavigationRail on large screens', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1600, 1200));
      await tester.pumpSubject(
        AirplaneEntertainmentSystemView(
          navigationShell,
          const [
            OverviewPage(),
            MusicPlayerPage(),
          ],
        ),
        AesLayoutData.large,
      );

      expect(find.byType(AesNavigationRail), findsOneWidget);
    });

    testWidgets('shows $AesBottomNavigationBar on small screens',
        (tester) async {
      await tester.pumpSubject(
        AirplaneEntertainmentSystemView(
          navigationShell,
          const [
            OverviewPage(),
            MusicPlayerPage(),
          ],
        ),
        AesLayoutData.small,
      );

      expect(find.byType(AesBottomNavigationBar), findsOneWidget);
    });

    testWidgets('shows $TopButtonBar', (tester) async {
      await tester.pumpSubject(
        AirplaneEntertainmentSystemView(
          navigationShell,
          const [
            OverviewPage(),
            MusicPlayerPage(),
          ],
        ),
        AesLayoutData.small,
      );

      expect(find.byType(TopButtonBar), findsOneWidget);
    });

    testWidgets('contains background', (tester) async {
      await tester.pumpSubject(
        AirplaneEntertainmentSystemView(
          navigationShell,
          const [
            OverviewPage(),
            MusicPlayerPage(),
          ],
        ),
        AesLayoutData.small,
      );

      expect(find.byType(SystemBackground), findsOneWidget);
    });

    testWidgets('$OverviewPage selected initially', (tester) async {
      await tester.pumpSubject(
        AirplaneEntertainmentSystemView(
          navigationShell,
          const [
            OverviewPage(),
            MusicPlayerPage(),
          ],
        ),
        AesLayoutData.small,
      );

      expect(
        tester.widget(find.byType(NavigationBar)),
        isA<NavigationBar>()
            .having((widget) => widget.selectedIndex, 'index', 0),
      );
    });

    testWidgets(
        'verify navigation to $MusicPlayerPage '
        'when icon is selected', (tester) async {
      await tester.pumpSubject(
        AirplaneEntertainmentSystemView(
          navigationShell,
          const [
            OverviewPage(),
            MusicPlayerPage(),
          ],
        ),
        AesLayoutData.small,
      );

      await tester.tap(find.byIcon(Icons.music_note));
      await tester.pump(const Duration(milliseconds: 350));

      verify(() => navigationShell.goBranch(1)).called(1);
    });

    for (final layout in AesLayoutData.values) {
      testWidgets(
          'verify navigation to $OverviewPage when icon is '
          'selected for $layout layout', (tester) async {
        await tester.pumpSubject(
          AirplaneEntertainmentSystemView(
            navigationShell,
            const [
              OverviewPage(),
              MusicPlayerPage(),
            ],
          ),
          layout,
        );

        await tester.tap(find.byIcon(Icons.music_note));
        await tester.pump(const Duration(milliseconds: 300));

        verify(() => navigationShell.goBranch(1)).called(1);

        await tester.tap(find.byIcon(Icons.airplanemode_active_outlined));
        await tester.pump(const Duration(milliseconds: 300));

        verify(() => navigationShell.goBranch(0, initialLocation: true))
            .called(1);
      });
    }
  });
}

extension on WidgetTester {
  Future<void> pumpSubject(Widget widget, AesLayoutData layout) {
    final MusicPlayerCubit musicPlayerCubit = _MockMusicPlayerCubit();
    when(() => musicPlayerCubit.state).thenReturn(const MusicPlayerState());

    final WeatherBloc weatherBloc = _MockWeatherBloc();
    when(() => weatherBloc.state).thenReturn(const WeatherState());

    return pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: musicPlayerCubit),
          BlocProvider.value(value: weatherBloc),
        ],
        child: widget,
      ),
      layout: layout,
    );
  }
}
