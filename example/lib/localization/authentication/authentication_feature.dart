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

import 'authentication_feature_en.dart';

/// Callers can lookup localized strings with an instance of AuthenticationFeature
/// returned by `AuthenticationFeature.of(context)`.
///
/// Applications need to include `AuthenticationFeature.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'authentication/authentication_feature.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AuthenticationFeature.localizationsDelegates,
///   supportedLocales: AuthenticationFeature.supportedLocales,
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
/// be consistent with the languages listed in the AuthenticationFeature.supportedLocales
/// property.
abstract class AuthenticationFeature {
  AuthenticationFeature(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AuthenticationFeature? of(BuildContext context) {
    return Localizations.of<AuthenticationFeature>(
        context, AuthenticationFeature);
  }

  static const LocalizationsDelegate<AuthenticationFeature> delegate =
      _AuthenticationFeatureDelegate();

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

  /// The text on the login button.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// The text on the username field.
  ///
  /// In en, this message translates to:
  /// **'Please enter the user name.'**
  String get userNameField;

  /// The text on the password field.
  ///
  /// In en, this message translates to:
  /// **'Please enter the password'**
  String get passwordField;
}

class _AuthenticationFeatureDelegate
    extends LocalizationsDelegate<AuthenticationFeature> {
  const _AuthenticationFeatureDelegate();

  @override
  Future<AuthenticationFeature> load(Locale locale) {
    return SynchronousFuture<AuthenticationFeature>(
        lookupAuthenticationFeature(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AuthenticationFeatureDelegate old) => false;
}

AuthenticationFeature lookupAuthenticationFeature(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AuthenticationFeatureEn();
  }

  throw FlutterError(
      'AuthenticationFeature.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
