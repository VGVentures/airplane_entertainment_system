// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get goodVibes => 'Good Vibes';

  @override
  String get multipleArtists => 'Multiple Artists';

  @override
  String get remaining => 'Remaining';

  @override
  String remainingTime(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String get songs => 'songs';

  @override
  String get welcomeMessage => 'Welcome on board';

  @override
  String get welcomeSubtitle => 'Lunch will be served in\n10 minutes';

  @override
  String get clear => 'Clear';

  @override
  String get cloudy => 'Cloudy';

  @override
  String get rainy => 'Rainy';

  @override
  String get thunderstorms => 'Thunderstorms';

  @override
  String get weatherErrorMessage =>
      'Uh oh! There was an error while fetching the weather information.';

  @override
  String get trackingErrorMessage =>
      'Uh oh! There was an error while fetching the flight information.';

  @override
  String get overviewLabel => 'Home';

  @override
  String get musicLabel => 'Music';
}
