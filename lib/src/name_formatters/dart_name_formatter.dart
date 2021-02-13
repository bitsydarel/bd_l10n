/*
 * The Clear BSD License
 *
 * Copyright (c) 2021 Bitsy Darel
 * All rights reserved.
 */

import 'package:bd_l10n/src/feature_configuration.dart';
import 'package:bd_l10n/src/name_formatter.dart';

/// [NameFormatter] that format file name as dart file convention.
abstract class DartNameFormatter extends NameFormatter {
  @override
  Future<String> getLocalizationFileName(FeatureConfiguration feature) async {
    final String fileName = feature.name
        .toLowerCase()
        .split(' ')
        .where((String word) => word.trim().isNotEmpty)
        .join('_');

    return '$fileName.dart';
  }
}
