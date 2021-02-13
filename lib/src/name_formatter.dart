/*
 * The Clear BSD License
 *
 * Copyright (c) 2021 Bitsy Darel
 * All rights reserved.
 */

import 'package:bd_l10n/src/feature_configuration.dart';

/// Name formatter for localization.
abstract class NameFormatter {
  /// Format the localization file name.
  Future<String> getLocalizationFileName(final FeatureConfiguration feature);

  /// Format the localization class name.
  Future<String> getLocalizationClassName(final FeatureConfiguration feature);
}

/// [NameFormatter] extensions.
extension NameFormatterExtension on NameFormatter {
  /// Capitalise a sentence.
  String capitalize(String input) {
    if (input.trim().isEmpty) {
      return input;
    }

    if (input.length == 1) {
      return input.toUpperCase();
    }

    return '${input[0].toUpperCase()}${input.substring(1)}';
  }
}
