import 'package:airplane_entertainment_system/music_player/music_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MuteButton extends StatelessWidget {
  const MuteButton({super.key});

  @override
  Widget build(BuildContext context) {
    final mute = context.select((MusicPlayerCubit cubit) => cubit.state.mute);

    return IconButton(
      onPressed: () {
        context.read<MusicPlayerCubit>().toggleMute();
      },
      icon: Icon(mute ? Icons.volume_off : Icons.volume_up),
    );
  }
}
