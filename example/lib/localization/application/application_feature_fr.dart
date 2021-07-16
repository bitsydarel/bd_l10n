/*
 * The Clear BSD License
 *
 * Copyright (c) 2021 Bitsy Darel
 * All rights reserved.
 */

import 'application_feature.dart';

/// The translations for French (`fr`).
class ApplicationFeatureFr extends ApplicationFeature {
  ApplicationFeatureFr([String locale = 'fr']) : super(locale);

  @override
  String get applicationTitle => 'Flutter BD_L10n Demo App';

  @override
  String get homeDescription =>
      'Vous avez appuyé sur le bouton ce nombre de fois:';

  @override
  String get incrementButton => 'Incrémenter';
}
