/*
 * The Clear BSD License
 *
 * Copyright (c) 2021 Bitsy Darel
 * All rights reserved.
 */

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'application_feature_en.dart';
import 'application_feature_es.dart';
import 'application_feature_fr.dart';

/// Callers can lookup localized strings with an instance of ApplicationFeature
/// returned by `ApplicationFeature.of(context)`.
///
/// Applications need to include `ApplicationFeature.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'application/application_feature.dart';
///
/// return MaterialApp(
///   localizationsDelegates: ApplicationFeature.localizationsDelegates,
///   supportedLocales: ApplicationFeature.supportedLocales,
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
/// be consistent with the languages listed in the ApplicationFeature.supportedLocales
/// property.
abstract class ApplicationFeature {
  ApplicationFeature(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static ApplicationFeature? of(BuildContext context) {
    return Localizations.of<ApplicationFeature>(context, ApplicationFeature);
  }

  static const LocalizationsDelegate<ApplicationFeature> delegate =
      _ApplicationFeatureDelegate();

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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Flutter BD_L10n Demo App'**
  String get applicationTitle;

  /// Home page description
  ///
  /// In en, this message translates to:
  /// **'You have pushed the button this many times:'**
  String get homeDescription;

  /// Demo text, not used in the app
  ///
  /// In en, this message translates to:
  /// **'Increment'**
  String get incrementButton;

  /// No description provided for @unTranslatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Hey, i\'m here to showcase messages that are not translated'**
  String get unTranslatedMessage;
}

class _ApplicationFeatureDelegate
    extends LocalizationsDelegate<ApplicationFeature> {
  const _ApplicationFeatureDelegate();

  @override
  Future<ApplicationFeature> load(Locale locale) {
    return SynchronousFuture<ApplicationFeature>(
        lookupApplicationFeature(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_ApplicationFeatureDelegate old) => false;
}

ApplicationFeature lookupApplicationFeature(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return ApplicationFeatureEn();
    case 'es':
      return ApplicationFeatureEs();
    case 'fr':
      return ApplicationFeatureFr();
  }

  throw FlutterError(
      'ApplicationFeature.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
