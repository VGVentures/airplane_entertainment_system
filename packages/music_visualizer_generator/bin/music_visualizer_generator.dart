// Copyright 2022 The fftea authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// @Kirpal used this to generate the dummy visualizer data. If you want to
// hook up real audio data to the visualizer, you should reach out to him to
// discuss how this can be leveraged to convert actual audio data into a format
// suitable for the visualizer widget.

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:fftea/fftea.dart';
import 'package:wav/wav.dart';

Float64List normalizeRmsVolume(List<double> a, double target) {
  final b = Float64List.fromList(a);
  var squareSum = 0.0;
  for (final x in b) {
    squareSum += x * x;
  }
  final factor = target * math.sqrt(b.length / squareSum);
  for (var i = 0; i < b.length; ++i) {
    b[i] *= factor;
  }
  return b;
}

Uint64List linSpace(int end, int steps) {
  final a = Uint64List(steps);
  for (var i = 1; i < steps; ++i) {
    a[i - 1] = (end * i) ~/ steps;
  }
  a[steps - 1] = end;
  return a;
}

String gradient(double power) {
  const scale = 2;
  const levels = [' ', '░', '▒', '▓', '█'];
  var index = math.log((power * levels.length) * scale).floor();
  if (index < 0) index = 0;
  if (index >= levels.length) index = levels.length - 1;
  return levels[index];
}

double scaled(double power) {
  return math.log(power);
}

void main(List<String> argv) async {
  if (argv.length != 1) {
    print('Wrong number of args. Usage:');
    print('  dart run spectrogram.dart test.wav');
    return;
  }
  final wav = await Wav.readFile(argv[0]);
  final audio = normalizeRmsVolume(wav.toMono(), 0.3);
  const chunkSize = 2048;
  const buckets = 20;
  final stft = STFT(chunkSize, Window.hanning(chunkSize));
  Uint64List? logItr;
  final spectrogram = <List<double>>[];
  stft.run(
    audio,
    (Float64x2List chunk) {
      final spectrogramRow = <double>[];
      final amp = chunk.discardConjugates().magnitudes();
      logItr ??= linSpace(amp.length, buckets);
      var i0 = 0;
      for (final i1 in logItr!) {
        var power = 0.0;
        if (i1 != i0) {
          for (var i = i0; i < i1; ++i) {
            power += amp[i];
          }
          power /= i1 - i0;
        }
        // stdout.write(gradient(power));
        spectrogramRow.add(scaled(power));
        i0 = i1;
      }
      // stdout.write('\n');
      spectrogram.add(spectrogramRow);
    },
    chunkSize ~/ 2,
  );
  final min = spectrogram.map((row) => row.reduce(math.min)).reduce(math.min);
  final max = spectrogram.map((row) => row.reduce(math.max)).reduce(math.max);

  for (final row in spectrogram) {
    final newRow = <double>[];

    for (final power in row) {
      newRow.add((power - min) / (max - min));
    }

    row
      ..clear()
      ..addAll(newRow);
  }

  stdout.write(jsonEncode(spectrogram));
  // stdout.write(nRows);
}
