import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;

class Clouds extends StatefulWidget {
  const Clouds({
    required this.count,
    required this.averageScale,
    required this.averageVelocity,
    super.key,
  });

  /// The number of clouds to draw.
  final int count;

  /// The average scale of the clouds. This is sort of an arbitrary number,
  /// where [1] is a medium sized cloud, and you can give any value greater than
  /// zero to adjust the average cloud size.
  final double averageScale;

  /// The average velocity of the clouds. This value describes how long it takes
  /// for an average cloud to go from the top to the botttom of the container.
  /// Clouds with and [averageVelocity] of [1] will take an average of 20
  /// seconds to traverse the container, and you can supply any value greater
  /// than zero to adjust this, where larger values will make the clouds travel
  /// faster.
  final double averageVelocity;

  @override
  State<Clouds> createState() => _CloudBackgroundState();
}

class _CloudBackgroundState extends State<Clouds>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  /// Indicates that the clouds are generated and ready to be drawn.
  bool ready = false;
  late final List<Cloud> clouds;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      value: 0.5,
      duration: Duration(seconds: 20 ~/ widget.averageVelocity),
    )..repeat();

    _renderClouds();
  }

  Future<void> _renderClouds() async {
    clouds = await CloudGenerator().generate(widget.count, widget.averageScale);

    setState(() {
      ready = true;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (final cloud in clouds) {
      cloud.image.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, _) {
        return CustomPaint(
          painter: ready
              ? _CloudsPainter(
                  t: _animationController.value,
                  clouds: clouds,
                )
              : null,
        );
      },
    );
  }
}

class _CloudsPainter extends CustomPainter {
  _CloudsPainter({
    required this.t,
    required this.clouds,
  });

  final double t;
  final List<Cloud> clouds;

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < clouds.length; i += 1) {
      final cloud = clouds[i];
      final startTime = i / clouds.length;
      final progress = t >= startTime ? t - startTime : 1 - startTime + t;
      final distance = cloud.velocity * size.height + cloud.image.height;
      final x = cloud.relativeX * (size.width - cloud.image.width);
      final y = distance * progress - cloud.image.height;

      canvas.drawImage(cloud.image, Offset(x, y), Paint());
    }
  }

  @override
  bool shouldRepaint(covariant _CloudsPainter oldDelegate) =>
      t != oldDelegate.t;
}

class CloudGenerator {
  CloudGenerator([Random? random]) : random = random ?? Random();

  final Random random;

  static const _maxRelativeRadius = 1 / 4;

  Future<List<Cloud>> generate(int count, double averageScale) async {
    final sizes = List.generate(
      count,
      (_) {
        final width = (400.0 + random.nextInt(600)) * averageScale;
        final height = 2 * width / 3 + random.nextInt(width ~/ 3);
        return Size(width, height);
      },
    );
    final images = await Future.wait(sizes.map(_generateCloudImage));
    return [
      for (var i = 0; i < images.length; i += 1)
        Cloud(
          image: images[i],
          relativeX: i / count + random.nextDouble() / count,
          velocity: 1 + random.nextDouble() / 2,
        ),
    ];
  }

  List<CloudParticle> _generateParticles() {
    final particles = <CloudParticle>[];
    for (var i = 0; i < 100; i += 1) {
      final phi = random.nextDouble() * pi * 2;
      final rho = pow(random.nextDouble(), 2).toDouble();
      final relativeRadius = _maxRelativeRadius / 2 * (1 + random.nextDouble());
      particles.add(CloudParticle(phi, rho, relativeRadius));
    }
    return particles;
  }

  Future<Image> _generateCloudImage(Size size) {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder)
      ..scale(
        size.width / (size.width + 2 * size.width * _maxRelativeRadius),
        size.height / (size.height + 2 * size.width * _maxRelativeRadius),
      )
      ..translate(
        size.width * _maxRelativeRadius,
        size.width * _maxRelativeRadius,
      )
      ..save();
    final particles = _generateParticles();
    final opacity = 0.05 + random.nextDouble() / 10;
    final gradient = RadialGradient(
      colors: [
        Colors.white.withOpacity(opacity),
        Colors.white.withOpacity(0),
      ],
      stops: const [0.6, 1],
    );

    for (final p in particles) {
      final x = sqrt(p.rho) * cos(p.phi) * size.width / 2;
      final y = sqrt(p.rho) * sin(p.phi) * size.height / 2;
      final center = size.center(Offset(x, y));
      final rect = Rect.fromCircle(
        center: center,
        radius: p.relativeRadius * size.width,
      );
      final paint = Paint()..shader = gradient.createShader(rect);

      canvas.drawOval(
        rect,
        paint,
      );
    }

    canvas.restore();
    final picture = recorder.endRecording();
    return picture.toImage(
      size.width.toInt(),
      size.height.toInt(),
    );
  }
}

/// {@template cloud}
/// Contains information to draw a single cloud image. This is generated by the
/// [CloudGenerator].
/// {@endtemplate}
class Cloud {
  /// {@macro cloud}
  const Cloud({
    required this.image,
    required this.relativeX,
    required this.velocity,
  });

  final Image image;
  final double relativeX;
  final double velocity;
}

/// {@template cloud_particle}
/// Contains information about a single particle in a cloud. This is used
/// internally by the [CloudGenerator] to create and draw a [Cloud] image.
/// {@endtemplate}
class CloudParticle {
  /// {@macro cloud_particle}
  const CloudParticle(this.phi, this.rho, this.relativeRadius);

  final double phi;
  final double rho;
  final double relativeRadius;
}