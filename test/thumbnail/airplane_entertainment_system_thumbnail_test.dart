import 'package:airplane_entertainment_system/demo/demo.dart';
import 'package:airplane_entertainment_system/overview/overview.dart';
import 'package:airplane_entertainment_system/thumbnail/thumbnail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/helpers.dart';

void main() {
  group('AirplaneEntertainmentSystemThumbnail', () {
    testWidgets('renders an airplane image and clouds', (tester) async {
      await tester.pumpExperience(const AirplaneEntertainmentSystemThumbnail());
      expect(find.byType(Clouds), findsNWidgets(2));
      expect(find.byType(AirplaneImage), findsOneWidget);
    });
  });
}
