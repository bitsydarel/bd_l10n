/*
 * The Clear BSD License
 *
 * Copyright (c) 2021 Bitsy Darel
 * All rights reserved.
 */

import 'package:bd_l10n/src/configuration.dart';
import 'package:bd_l10n/src/name_formatter.dart';
import 'package:bd_l10n/src/utils.dart';

/// Localization builder.
///
/// Build localization for the specified [configuration].
abstract class LocalizationBuilder {
  /// Configuration of the [utilityName].
  final Configuration configuration;

  /// Format name to match the proper project convention.
  final NameFormatter nameFormatter;

  /// Create [LocalizationBuilder] with [configuration] and [nameFormatter].
  const LocalizationBuilder(this.configuration, this.nameFormatter);

  /// Build the localizations.
  Future<void> build();
}
