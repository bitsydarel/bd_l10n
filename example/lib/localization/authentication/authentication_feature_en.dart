/*
 * The Clear BSD License
 *
 * Copyright (c) 2021 Bitsy Darel
 * All rights reserved.
 */

import 'authentication_feature.dart';

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
