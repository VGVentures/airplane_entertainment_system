/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsWeatherGen {
  const $AssetsWeatherGen();

  /// File path: assets/weather/clear.png
  AssetGenImage get clear => const AssetGenImage('assets/weather/clear.png');

  /// File path: assets/weather/cloudy.png
  AssetGenImage get cloudy => const AssetGenImage('assets/weather/cloudy.png');

  /// File path: assets/weather/rainy.png
  AssetGenImage get rainy => const AssetGenImage('assets/weather/rainy.png');

  /// File path: assets/weather/thunderstorms.png
  AssetGenImage get thunderstorms =>
      const AssetGenImage('assets/weather/thunderstorms.png');

  /// List of all assets
  List<AssetGenImage> get values => [clear, cloudy, rainy, thunderstorms];
}

class Assets {
  Assets._();

  static const AssetGenImage airplane = AssetGenImage('assets/airplane.png');
  static const AssetGenImage music = AssetGenImage('assets/music.jpg');
  static const String spectrogram = 'assets/spectrogram.json';
  static const AssetGenImage spiderman = AssetGenImage('assets/spiderman.png');
  static const AssetGenImage vgvLogo = AssetGenImage('assets/vgv_logo.png');
  static const $AssetsWeatherGen weather = $AssetsWeatherGen();

  /// List of all assets
  static List<dynamic> get values =>
      [airplane, music, spectrogram, spiderman, vgvLogo];
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
