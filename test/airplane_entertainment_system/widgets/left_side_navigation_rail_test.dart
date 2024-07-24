import 'package:airplane_entertainment_system/airplane_entertainment_system/airplane_entertainment_system.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomRectangularShape', () {
    test('verifies should not reclip', () async {
      final path = CustomRectangularShape();
      expect(path.shouldReclip(path), false);
    });
  });
}
