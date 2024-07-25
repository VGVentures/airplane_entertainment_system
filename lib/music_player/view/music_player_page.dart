import 'package:aes_ui/aes_ui.dart';
import 'package:airplane_entertainment_system/l10n/l10n.dart';
import 'package:airplane_entertainment_system/music_player/music_player.dart';
import 'package:flutter/material.dart';

class MusicPlayerPage extends StatelessWidget {
  const MusicPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Expanded(
          flex: 3,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 100),
              child: MusicPlayerView(),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 100),
            child: const MusicMenuView(),
          ),
        ),
      ],
    );
  }
}

class MusicPlayerView extends StatelessWidget {
  const MusicPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        iconTheme: IconThemeData(size: 28, color: Colors.grey.shade800),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: IconButton(
                  padding: const EdgeInsets.all(12),
                  onPressed: () {},
                  iconSize: 16,
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.first_page_rounded),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const MusicVisualizer(),
                          SizedBox(
                            height: 300,
                            width: 300,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 130,
                            width: 130,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.pause,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.last_page_rounded),
                  ],
                ),
                const SizedBox(height: 40),
                Flexible(
                  child: Row(
                    children: [
                      const Icon(Icons.shuffle),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Card(
                          elevation: 0,
                          color: Colors.transparent,
                          child: SizedBox(
                            width: 360,
                            child: Slider(
                              inactiveColor: Colors.grey,
                              activeColor: Colors.red,
                              thumbColor: Colors.white,
                              value: 0,
                              onChanged: (_) {},
                            ),
                          ),
                        ),
                      ),
                      const Icon(Icons.repeat_rounded),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MusicMenuView extends StatelessWidget {
  const MusicMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: _MusicMenuHeader(),
          ),
          Flexible(
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.white,
                  Colors.white.withOpacity(0),
                ],
                stops: const [0, 0.8, 0.9],
              ).createShader(bounds),
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.only(bottom: 100),
                itemBuilder: (context, pos) => _MusicMenuItem(
                  title: _musicItems[pos]['title']!,
                  artist: _musicItems[pos]['artist']!,
                  trackPosition: pos + 1,
                  isPlaying: pos == 0,
                ),
                separatorBuilder: (_, __) => const Divider(
                  color: Colors.transparent,
                ),
                itemCount: _musicItems.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const _musicItems = [
  {'title': 'Starlight', 'artist': 'Muse'},
  {'title': 'E a verdade', 'artist': 'Riles'},
  {'title': 'Dance Monkey', 'artist': 'Tones and I'},
  {'title': 'La Campanella', 'artist': 'Chopin'},
  {'title': 'Calm Down', 'artist': 'Rema'},
];

class _MusicMenuHeader extends StatelessWidget {
  const _MusicMenuHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.goodVibes,
          style: AesTextStyles.headlineLarge,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 10),
        Text(
          '${l10n.multipleArtists}\n26 ${l10n.songs}',
          style: TextStyle(
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }
}

class _MusicMenuItem extends StatelessWidget {
  const _MusicMenuItem({
    required this.title,
    required this.artist,
    required this.trackPosition,
    this.isPlaying = false,
  });

  final String title;
  final String artist;
  final int trackPosition;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: 90,
      child: DecoratedBox(
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(trackPosition.toString()),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          artist,
                          style: const TextStyle(color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  ),
                ],
              ),
            ),
            if (isPlaying)
              SizedBox(
                height: size.height,
                width: 5,
                child: const DecoratedBox(
                  decoration: BoxDecoration(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
