import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'airplane_entertainment_system_localizations_en.dart';

/// Callers can lookup localized strings with an instance of AirplaneEntertainmentSystemLocalizations
/// returned by `AirplaneEntertainmentSystemLocalizations.of(context)`.
///
/// Applications need to include `AirplaneEntertainmentSystemLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/airplane_entertainment_system_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AirplaneEntertainmentSystemLocalizations.localizationsDelegates,
///   supportedLocales: AirplaneEntertainmentSystemLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AirplaneEntertainmentSystemLocalizations.supportedLocales
/// property.
abstract class AirplaneEntertainmentSystemLocalizations {
  AirplaneEntertainmentSystemLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AirplaneEntertainmentSystemLocalizations of(BuildContext context) {
    return Localizations.of<AirplaneEntertainmentSystemLocalizations>(
        context, AirplaneEntertainmentSystemLocalizations)!;
  }

  static const LocalizationsDelegate<AirplaneEntertainmentSystemLocalizations>
      delegate = _AirplaneEntertainmentSystemLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// The initial message of the experience
  ///
  /// In en, this message translates to:
  /// **'Hello Experience'**
  String get helloExperience;

  /// No description provided for @goodVibes.
  ///
  /// In en, this message translates to:
  /// **'Good Vibes'**
  String get goodVibes;

  /// No description provided for @multipleArtists.
  ///
  /// In en, this message translates to:
  /// **'Multiple Artists'**
  String get multipleArtists;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'mins'**
  String get minutesShort;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @songs.
  ///
  /// In en, this message translates to:
  /// **'songs'**
  String get songs;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome on board'**
  String get welcomeMessage;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Lunch will be served in\n10 minutes'**
  String get welcomeSubtitle;

  /// No description provided for @assistButton.
  ///
  /// In en, this message translates to:
  /// **'ASSIST'**
  String get assistButton;

  /// No description provided for @thunderstorms.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorms'**
  String get thunderstorms;
}

class _AirplaneEntertainmentSystemLocalizationsDelegate
    extends LocalizationsDelegate<AirplaneEntertainmentSystemLocalizations> {
  const _AirplaneEntertainmentSystemLocalizationsDelegate();

  @override
  Future<AirplaneEntertainmentSystemLocalizations> load(Locale locale) {
    return SynchronousFuture<AirplaneEntertainmentSystemLocalizations>(
        lookupAirplaneEntertainmentSystemLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AirplaneEntertainmentSystemLocalizationsDelegate old) =>
      false;
}

AirplaneEntertainmentSystemLocalizations
    lookupAirplaneEntertainmentSystemLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AirplaneEntertainmentSystemLocalizationsEn();
  }

  throw FlutterError(
      'AirplaneEntertainmentSystemLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
