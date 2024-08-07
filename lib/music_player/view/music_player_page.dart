import 'package:aes_ui/aes_ui.dart';
import 'package:airplane_entertainment_system/l10n/l10n.dart';
import 'package:airplane_entertainment_system/music_player/music_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_repository/music_repository.dart';

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
          child: const _PlayingMusicVisualizer(),
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
                  builder: (_) => BlocProvider.value(
                    value: context.read<MusicPlayerCubit>(),
                    child: const _MusicBottomSheet(),
                  ),
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
              BlocSelector<MusicPlayerCubit, MusicPlayerState, MusicTrack?>(
                selector: (state) => state.currentTrack,
                builder: (context, track) {
                  if (track == null) return const SizedBox();
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(' - '),
                      Text(track.artist),
                    ],
                  );
                },
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
                    IconButton(
                      onPressed: () =>
                          context.read<MusicPlayerCubit>().previous(),
                      icon: const Icon(Icons.first_page_rounded),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const _PlayingMusicVisualizer(),
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
                              child: Center(
                                child: InkWell(
                                  onTap: () => context
                                      .read<MusicPlayerCubit>()
                                      .togglePlayPause(),
                                  child: BlocSelector<MusicPlayerCubit,
                                      MusicPlayerState, bool>(
                                    selector: (state) => state.isPlaying,
                                    builder: (context, isPlaying) {
                                      return Icon(
                                        isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        size: 40,
                                        color: Colors.white,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => context.read<MusicPlayerCubit>().next(),
                      icon: const Icon(Icons.last_page_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Flexible(
                  child: Row(
                    children: [
                      BlocSelector<MusicPlayerCubit, MusicPlayerState, bool>(
                        selector: (state) => state.isShuffle,
                        builder: (context, enabled) {
                          return IconButton(
                            color: enabled ? Colors.red : null,
                            onPressed: () => context
                                .read<MusicPlayerCubit>()
                                .toggleShuffle(),
                            icon: const Icon(Icons.shuffle),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Card(
                          elevation: 0,
                          color: Colors.transparent,
                          child: SizedBox(
                            width: 360,
                            child: BlocSelector<MusicPlayerCubit,
                                MusicPlayerState, double>(
                              selector: (state) => state.progress,
                              builder: (context, progress) {
                                return Slider(
                                  inactiveColor: Colors.grey,
                                  activeColor: Colors.red,
                                  thumbColor: Colors.white,
                                  value: progress,
                                  onChanged: (value) => context
                                      .read<MusicPlayerCubit>()
                                      .seek(value),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      BlocSelector<MusicPlayerCubit, MusicPlayerState, bool>(
                        selector: (state) => state.isLoop,
                        builder: (context, enabled) {
                          return IconButton(
                            color: enabled ? Colors.red : null,
                            onPressed: () =>
                                context.read<MusicPlayerCubit>().toggleLoop(),
                            icon: const Icon(Icons.repeat_rounded),
                          );
                        },
                      ),
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

class _PlayingMusicVisualizer extends StatelessWidget {
  const _PlayingMusicVisualizer();

  @override
  Widget build(BuildContext context) {
    final isPlaying = context.select<MusicPlayerCubit, bool>(
      (cubit) => cubit.state.isPlaying,
    );
    return MusicVisualizer(isActive: isPlaying);
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
              child: BlocSelector<MusicPlayerCubit, MusicPlayerState,
                  (List<MusicTrack>, MusicTrack?, bool)>(
                selector: (state) => (
                  state.tracks,
                  state.currentTrack,
                  state.isPlaying,
                ),
                builder: (context, state) {
                  final (tracks, current, isPlaying) = state;
                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: padding?.copyWith(top: 0),
                    itemBuilder: (context, pos) {
                      final track = tracks[pos];
                      return _MusicMenuItem(
                        track: track,
                        isCurrent: track == current,
                        isPlaying: isPlaying,
                        onTap: () =>
                            context.read<MusicPlayerCubit>().playTrack(track),
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(
                      color: Colors.transparent,
                    ),
                    itemCount: tracks.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MusicMenuHeader extends StatelessWidget {
  const _MusicMenuHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final count = context.select<MusicPlayerCubit, int>(
      (cubit) => cubit.state.tracks.length,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          child: Text(
            l10n.goodVibes,
            style: AesTextStyles.headlineLarge,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '${l10n.multipleArtists}\n$count ${l10n.songs}',
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
    required this.track,
    this.onTap,
    this.isCurrent = false,
    this.isPlaying = false,
  });

  final MusicTrack track;
  final bool isCurrent;
  final bool isPlaying;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: SizedBox(
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
                      child: Text((track.index + 1).toString()),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            track.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            track.artist,
                            style: const TextStyle(color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isCurrent && isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                    ),
                  ],
                ),
              ),
              if (isCurrent)
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
      ),
    );
  }
}
