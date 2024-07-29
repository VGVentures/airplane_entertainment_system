import 'package:airplane_entertainment_system/generated/assets.gen.dart';
import 'package:airplane_entertainment_system/l10n/l10n.dart';
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
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.power_settings_new),
            ),
            Container(
              width: 1,
              height: 24,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.white.withOpacity(0.3),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.brightness_7),
            ),
            Container(
              width: 1,
              height: 24,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.white.withOpacity(0.3),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.volume_up),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800,
                padding: const EdgeInsets.all(16),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
              icon: const Icon(Icons.support, color: Colors.white),
              label: Text(
                context.l10n.assistButton,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
