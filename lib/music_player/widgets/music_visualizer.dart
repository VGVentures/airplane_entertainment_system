import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

class MusicVisualizer extends StatefulWidget {
  const MusicVisualizer({required this.isActive, super.key});

  final bool isActive;

  @override
  State<MusicVisualizer> createState() => MusicVisualizerState();
}

@visibleForTesting
class MusicVisualizerState extends State<MusicVisualizer>
    with TickerProviderStateMixin {
  bool ready = false;
  late final AnimationController animationController;
  late final AnimationController extensionController;
  late final List<List<double>> spectrogram;
  late int spectrogramIndex;
  late List<Tween<double>> frequencyTweens;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );
    extensionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    if (widget.isActive) {
      extensionController.value = 1;
    }
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _loadSpectrogram();
  }

  @override
  void didUpdateWidget(covariant MusicVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive) {
      extensionController.forward();
    } else {
      extensionController.reverse();
    }
  }

  Future<void> _loadSpectrogram() async {
    final spectrogramData = await DefaultAssetBundle.of(context).loadString(
      'assets/spectrogram.json',
    );
    spectrogramIndex = 0;
    spectrogram = (jsonDecode(spectrogramData) as List)
        .map(
          (e) => (e as List)
              // TODO(jolexxa): very bad hack to chop off the lowest and
              // highest frequencies of the spectrograph. This makes the
              // visualizer look more appealing.
              .sublist(2, e.length - 2)
              .map((e) => (e as num).toDouble())
              .toList(),
        )
        .toList();

    frequencyTweens = [
      for (final frequency in spectrogram[spectrogramIndex])
        ConstantTween<double>(frequency),
    ];
    animationController
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            final oldSpectrogramIndex = spectrogramIndex;

            spectrogramIndex += 1;

            if (spectrogramIndex >= spectrogram.length) {
              spectrogramIndex = 0;
            }

            frequencyTweens = [
              for (var i = 0; i < frequencyTweens.length; i++)
                Tween<double>(
                  begin: spectrogram[oldSpectrogramIndex][i],
                  end: spectrogram[spectrogramIndex][i],
                ),
            ];
          });
          animationController.forward(from: 0);
        }
      });

    setState(() {
      ready = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!ready) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: Listenable.merge([animationController, extensionController]),
      builder: (context, _) => CustomPaint(
        painter: _MusicVisualizerPainter(
          channels: frequencyTweens
              .map(
                (tween) =>
                    tween.transform(animationController.value) *
                    extensionController.value,
              )
              .toList(),
        ),
      ),
    );
  }
}

class _MusicVisualizerPainter extends CustomPainter {
  _MusicVisualizerPainter({required List<double> channels})
      : _channels = channels;

  static const _innerRadius = 160.0;
  static const _outerRadius = 200.0;

  final List<double> _channels;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final arcLength = 2 * pi / _channels.length;

    path.moveTo(_innerRadius, 0);

    for (var i = 0; i < _channels.length; i++) {
      final channel = _channels[i];
      const r0 = _innerRadius;
      final r1 = _innerRadius + channel * (_outerRadius - _innerRadius);
      const r2 = _innerRadius;

      final angle0 = arcLength * i;
      final angle1 = arcLength * (i + 0.5);
      final angle2 = arcLength * (i + 1);

      _smoothCurve(path, r0, angle0, r1, angle1, canvas);
      _smoothCurve(path, r1, angle1, r2, angle2, canvas);
    }
    canvas.drawPath(path, Paint()..color = Colors.blue.withOpacity(0.5));
  }

  void _smoothCurve(
    Path path,
    double r1,
    double angle1,
    double r2,
    double angle2,
    Canvas canvas,
  ) {
    final x0 = r1 * cos(angle1);
    final y0 = r1 * sin(angle1);

    final x3 = r2 * cos(angle2);
    final y3 = r2 * sin(angle2);

    final distance1 = sqrt(2 * pow(r1, 2) * (1 - cos(angle2 - angle1)));
    final distance2 = sqrt(2 * pow(r2, 2) * (1 - cos(angle2 - angle1)));
    final distance = (distance1 + distance2) / 2;

    final double x1;
    final double y1;
    final double x2;
    final double y2;

    final m1 = y0 != 0 ? atan(-x0 / y0) : pi / 2;
    final sign1 = y0 <= 0 ? 1 : -1;
    x1 = x0 + sign1 * distance / 4 * cos(m1);
    y1 = y0 + sign1 * distance / 4 * sin(m1);

    final m2 = y3 != 0 ? atan(-x3 / y3) : pi / 2;
    final sign2 = y3 < 0 ? 1 : -1;
    x2 = x3 - sign2 * distance / 4 * cos(m2);
    y2 = y3 - sign2 * distance / 4 * sin(m2);

    path.cubicTo(x1, y1, x2, y2, x3, y3);
  }

  @override
  bool shouldRepaint(covariant _MusicVisualizerPainter oldDelegate) =>
      _channels != oldDelegate._channels;
}
