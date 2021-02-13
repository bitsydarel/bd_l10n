/*
 * The Clear BSD License
 *
 * Copyright (c) 2021 Bitsy Darel
 * All rights reserved.
 */

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'application_feature.dart';

// ignore_for_file: unnecessary_brace_in_string_interps

/// The translations for English (`en`).
class ApplicationFeatureEn extends ApplicationFeature {
  ApplicationFeatureEn([String locale = 'en']) : super(locale);

  @override
  String get applicationTitle => 'Flutter BD_L10n Demo App';

  @override
  String get homeDescription => 'You have pushed the button this many times:';

  @override
  String get incrementButton => 'Increment';
}
