/*
 * The Clear BSD License
 *
 * Copyright (c) 2021 Bitsy Darel
 * All rights reserved.
 */

import 'package:bd_l10n/src/feature_configuration.dart';
import 'package:bd_l10n/src/name_formatter.dart';
import 'package:bd_l10n/src/name_formatters/dart_name_formatter.dart';

/// [NameFormatter] that format class name with camel case.
class CamelCaseNameFormatter extends DartNameFormatter {
  @override
  Future<String> getLocalizationClassName(FeatureConfiguration feature) async {
    final Iterable<String> words = feature.name
        .split(' ')
        .map((String word) => word.trim())
        .where((String word) => word.isNotEmpty)
        .map(capitalize);

    return words.join();
  }
}
