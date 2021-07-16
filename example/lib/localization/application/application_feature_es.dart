/*
 * The Clear BSD License
 *
 * Copyright (c) 2021 Bitsy Darel
 * All rights reserved.
 */

import 'application_feature.dart';

/// The translations for Spanish Castilian (`es`).
class ApplicationFeatureEs extends ApplicationFeature {
  ApplicationFeatureEs([String locale = 'es']) : super(locale);

  @override
  String get applicationTitle => 'Flutter BD_L10n Demo App';

  @override
  String get homeDescription => 'Has pulsado el botón tantas veces:';

  @override
  String get incrementButton => 'Incremento';
}
