import 'package:aes_ui/aes_ui.dart';
import 'package:airplane_entertainment_system/l10n/l10n.dart';
import 'package:airplane_entertainment_system/music_player/music_player.dart';
import 'package:flutter/material.dart';

class MusicPlayerPage extends StatelessWidget {
  const MusicPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final layout = AesLayout.of(context);

    return switch (layout) {
      AesLayoutData.small => const _SmallMusicPlayerPage(),
      AesLayoutData.medium ||
      AesLayoutData.large =>
        const _LargeMusicPlayerPage(),
    };
  }
}

class _SmallMusicPlayerPage extends StatelessWidget {
  const _SmallMusicPlayerPage();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        MusicMenuView(
          padding: EdgeInsets.only(
            right: 20,
            left: 20,
            bottom: 60,
          ),
        ),
        Positioned(
          bottom: 20,
          right: 30,
          child: MusicFloatingButton(),
        ),
      ],
    );
  }
}

class _LargeMusicPlayerPage extends StatelessWidget {
  const _LargeMusicPlayerPage();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 100),
              child: MusicPlayerView(),
            ),
          ),
        ),
        Expanded(
          child: MusicMenuView(
            padding: EdgeInsets.only(
              top: 40,
              right: 80,
              left: 40,
              bottom: 100,
            ),
          ),
        ),
      ],
    );
  }
}

class MusicFloatingButton extends StatelessWidget {
  const MusicFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.scale(
          scale: 0.2,
          child: const MusicVisualizer(),
        ),
        SizedBox(
          height: 50,
          width: 50,
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
            child: InkWell(
              onTap: () {
                showBottomSheet(
                  backgroundColor: Colors.white,
                  context: context,
                  constraints: const BoxConstraints(
                    maxHeight: 380,
                  ),
                  builder: (_) => const _MusicBottomSheet(),
                );
              },
              child: Center(
                child: Icon(
                  Icons.play_circle,
                  size: 32,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MusicBottomSheet extends StatelessWidget {
  const _MusicBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(40).copyWith(bottom: 0),
          child: Column(
            children: [
              const SizedBox(
                width: 350,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: MusicPlayerView(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _musicItems[0]['title']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(' - '),
                  Text(_musicItems[0]['artist']!),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: IconButton(
            onPressed: Navigator.of(context).pop,
            icon: const Icon(
              Icons.close_rounded,
              size: 30,
            ),
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
  const MusicMenuView({super.key, this.padding});

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white,
          Colors.white,
          Colors.white.withOpacity(0),
        ],
        stops: const [0, 0.9, 0.99],
      ).createShader(bounds),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20) +
                  (padding?.copyWith(bottom: 0) ?? EdgeInsets.zero),
              child: const _MusicMenuHeader(),
            ),
            Flexible(
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: padding?.copyWith(top: 0),
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
          ],
        ),
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
          maxLines: 2,
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
