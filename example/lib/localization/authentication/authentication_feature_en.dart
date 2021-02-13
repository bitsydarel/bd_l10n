/*
 * The Clear BSD License
 *
 * Copyright (c) 2021 Bitsy Darel
 * All rights reserved.
 */

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'authentication_feature.dart';

// ignore_for_file: unnecessary_brace_in_string_interps

/// The translations for English (`en`).
class AuthenticationFeatureEn extends AuthenticationFeature {
  AuthenticationFeatureEn([String locale = 'en']) : super(locale);

  @override
  String get loginButton => 'Login';

  @override
  String get userNameField => 'Please enter the user name.';

  @override
  String get passwordField => 'Please enter the password';
}
