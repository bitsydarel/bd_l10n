/*
 * The Clear BSD License
 *
 * Copyright (c) 2021 Bitsy Darel
 * All rights reserved.
 */

import 'dart:async';

import 'package:bd_l10n/src/configuration.dart';
import 'package:bd_l10n/src/utils.dart';

/// Localization watcher.
///
/// Watch localization from the specified [configuration] for changes.
abstract class LocalizationWatcher {
  /// [utilityName] configuration.
  final Configuration configuration;

  /// Create a [LocalizationWatcher] with [configuration].
  LocalizationWatcher(this.configuration);

  /// Start localization watch.
  Future<void> startWatch();

  /// Stop localization watch.
  Future<void> stopWatch();
}
