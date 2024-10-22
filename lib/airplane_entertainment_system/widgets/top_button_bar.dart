import 'package:airplane_entertainment_system/airplane_entertainment_system/airplane_entertainment_system.dart';
import 'package:airplane_entertainment_system/generated/assets.gen.dart';
import 'package:flutter/material.dart';

class TopButtonBar extends StatelessWidget {
  const TopButtonBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: IconTheme(
        data: const IconThemeData(
          color: Colors.white,
        ),
        child: Row(
          children: [
            Assets.vgvLogo.image(width: 40, height: 40),
            const SizedBox(width: 24),
            const MuteButton(),
          ],
        ),
      ),
    );
  }
}
