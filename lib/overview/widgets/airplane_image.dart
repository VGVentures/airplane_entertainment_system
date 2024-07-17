import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class AirplaneImage extends StatelessWidget {
  const AirplaneImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Image.asset(
            'assets/airplane.png',
            fit: BoxFit.contain,
            color: const Color(0x33003366),
            colorBlendMode: BlendMode.srcIn,
          ),
        ),
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: const _ExhaustStream(),
        ),
        Image.asset(
          'assets/airplane.png',
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}

class _ExhaustStream extends StatefulWidget {
  const _ExhaustStream();

  @override
  State<_ExhaustStream> createState() => _ExhaustStreamState();
}

class _ExhaustStreamState extends State<_ExhaustStream>
    with SingleTickerProviderStateMixin {
  final xOffsets = _ExhaustPainter.generateXOffsets();
  late final _animationController = AnimationController(
    vsync: this,
    upperBound: xOffsets.length.toDouble(),
    duration: const Duration(seconds: 6),
  )..repeat();

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: SizedBox(
        width: 4405,
        height: 4082,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, _) {
            final firstOffset = (_animationController.value / 2).floor() * 2;

            return CustomPaint(
              painter: _ExhaustPainter(
                firstOffset: firstOffset,
                yOffset: _animationController.value - firstOffset,
                xOffsets: xOffsets,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ExhaustPainter extends CustomPainter {
  _ExhaustPainter({
    required this.firstOffset,
    required this.xOffsets,
    required this.yOffset,
  });

  final int firstOffset;
  final double yOffset;
  final List<_ExhaustXOffset> xOffsets;

  static List<_ExhaustXOffset> generateXOffsets() {
    final random = Random();
    double getOffset() => random.nextDouble() * 2 - 1;

    final xOffsets = <_ExhaustXOffset>[];
    const pointCount = 50;

    for (var j = 0; j < pointCount; j++) {
      xOffsets.add(
        _ExhaustXOffset(
          getOffset(),
          getOffset(),
          getOffset(),
          getOffset(),
        ),
      );
    }

    return xOffsets;
  }

  @override
  void paint(Canvas canvas, Size size) {
    drawWavyLine(
      canvas,
      xOffsets.map((o) => o.engine1).toList(),
      size.width * 25 / 128,
      size.height * 9 / 16,
      size.height,
    );
    drawWavyLine(
      canvas,
      xOffsets.map((o) => o.engine2).toList(),
      size.width * 21 / 64,
      size.height * 1 / 2,
      size.height,
    );
    drawWavyLine(
      canvas,
      xOffsets.map((o) => o.engine3).toList(),
      size.width * 43 / 64,
      size.height * 1 / 2,
      size.height,
    );
    drawWavyLine(
      canvas,
      xOffsets.map((o) => o.engine4).toList(),
      size.width * 103 / 128,
      size.height * 9 / 16,
      size.height,
    );
  }

  void drawWavyLine(
    Canvas canvas,
    List<double> xOffsets,
    double centerX,
    double fromY,
    double toY,
  ) {
    final controlPoints = <Offset>[];
    final pointCount = xOffsets.length;

    for (var i = 0; i < pointCount; i++) {
      final xOffset = firstOffset - i >= 0
          ? xOffsets[firstOffset - i]
          : xOffsets[pointCount + firstOffset - i];

      final offsetAmount = 30 * sqrt(i / pointCount);
      final x = centerX + xOffset * offsetAmount;
      final stepHeight = (toY - fromY) / pointCount;
      final y = fromY + stepHeight * (i + yOffset);
      controlPoints.add(Offset(x, y));
    }

    final leftPath = Path()..moveTo(controlPoints[0].dx, controlPoints[0].dy);
    final rightPath = Path()..moveTo(controlPoints[0].dx, controlPoints[0].dy);
    leftPath.cubicTo(
      controlPoints[1].dx - 25,
      controlPoints[1].dy,
      controlPoints[1].dx - 25,
      controlPoints[1].dy,
      controlPoints[2].dx - 25,
      controlPoints[2].dy,
    );
    rightPath.cubicTo(
      controlPoints[1].dx + 25,
      controlPoints[1].dy,
      controlPoints[1].dx + 25,
      controlPoints[1].dy,
      controlPoints[2].dx + 25,
      controlPoints[2].dy,
    );
    for (var i = 2; i < controlPoints.length - 2; i += 2) {
      final x1 =
          controlPoints[i].dx + controlPoints[i].dx - controlPoints[i - 1].dx;
      final y1 =
          controlPoints[i].dy + controlPoints[i].dy - controlPoints[i - 1].dy;
      final width = 50 + (100 * i / controlPoints.length);
      final halfWidth = width / 2;

      leftPath.cubicTo(
        x1 - halfWidth,
        y1,
        controlPoints[i + 1].dx - halfWidth,
        controlPoints[i + 1].dy,
        controlPoints[i + 2].dx - halfWidth,
        controlPoints[i + 2].dy,
      );
      rightPath.cubicTo(
        x1 + halfWidth,
        y1,
        controlPoints[i + 1].dx + halfWidth,
        controlPoints[i + 1].dy,
        controlPoints[i + 2].dx + halfWidth,
        controlPoints[i + 2].dy,
      );
    }
    leftPath.lineTo(centerX, toY);
    rightPath.lineTo(centerX, toY);

    final path = Path()
      ..addPath(leftPath, Offset.zero)
      ..addPath(rightPath, Offset.zero);

    final gradient = LinearGradient(
      colors: [
        Colors.white.withOpacity(0.6),
        Colors.white.withOpacity(0),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    canvas.drawPath(
      path,
      Paint()..shader = gradient.createShader(path.getBounds()),
    );
  }

  @override
  bool shouldRepaint(covariant _ExhaustPainter oldDelegate) =>
      yOffset != oldDelegate.yOffset || firstOffset != oldDelegate.firstOffset;
}

class _ExhaustXOffset {
  _ExhaustXOffset(this.engine1, this.engine2, this.engine3, this.engine4);

  final double engine1;
  final double engine2;
  final double engine3;
  final double engine4;
}
