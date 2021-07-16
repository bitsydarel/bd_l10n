/*
 * The Clear BSD License
 *
 * Copyright (c) 2021 Bitsy Darel
 * All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:bd_l10n/src/configuration.dart';
import 'package:bd_l10n/src/localization_builder.dart';
import 'package:bd_l10n/src/localization_builders/flutter_localization_builder.dart';
import 'package:bd_l10n/src/localization_watcher.dart';
import 'package:bd_l10n/src/localization_watchers/file_localization_watcher.dart';
import 'package:bd_l10n/src/name_formatter.dart';
import 'package:bd_l10n/src/name_formatters/camel_case_name_formatter.dart';
import 'package:io/ansi.dart';
import 'package:io/io.dart';

/// Utility name
const String utilityName = 'bd_l10n';

/// Configuration file name.
const String configFileName = '$utilityName.yaml';

/// Configuration file utility argument.
const String configFileArgument = 'config-file';

/// Enable file watcher in the utility.
const String enableFileWatcher = 'file-watcher';

/// Script parameter used to print help.
const String helpArgument = 'help';

/// Script argument parser.
final ArgParser argumentParser = ArgParser()
  ..addOption(
    configFileArgument,
    help: '$utilityName configuration file location',
  )
  ..addFlag(
    enableFileWatcher,
    defaultsTo: true,
    help: 'If on config file content changes and feature translation directory '
        'content changes event will automatically trigger '
        'localizations generation.\nIf you want to turn it off after running '
        'the script, just delete the ${utilityName}_*.lock file',
  )
  ..addFlag(
    helpArgument,
    help: 'Print help message',
  );

/// Print help message to the console.
void printHelpMessage([final String? message]) {
  if (message != null) {
    stderr.writeln(red.wrap('$message\n'));
  }

  final String options =
      LineSplitter.split(argumentParser.usage).map((String l) => l).join('\n');

  stdout.writeln(
    'Usage: bdl10n --$configFileArgument <local file path> '
    '<local project directory>\nOptions:\n$options',
  );
}

/// [Configuration] extensions.
extension ConfigurationExtension on Configuration {
  /// Create the [NameFormatter] matching the [Configuration].
  NameFormatter nameFormatter() {
    return CamelCaseNameFormatter();
  }

  /// Create the [LocalizationBuilder] matching the [Configuration] with the
  /// specified [nameFormatter].
  LocalizationBuilder builder(final NameFormatter nameFormatter) {
    switch (projectType) {
      case ProjectType.flutter:
        return FlutterLocalizationBuilder(this, nameFormatter);
      default:
        throw UnrecoverableException(
          'Project type is unsupported: $projectType',
          ExitCode.config.code,
        );
    }
  }

  /// Create the [LocalizationWatcher] matching the [Configuration] with the
  /// specified [configFilePath]
  LocalizationWatcher watcher(final String configFilePath) {
    return FileLocalizationWatcher(
      configFileLocation: configFilePath,
      configuration: this,
      startedAt: DateTime.now(),
    );
  }

  /// Generate localizations matching the current configuration.
  Future<void> generateLocalizations() async {
    final NameFormatter nameFormatter = this.nameFormatter();

    final LocalizationBuilder builder = this.builder(nameFormatter);

    await builder.build();
  }
}

/// A class that represent a exception that can't be recovered.
class UnrecoverableException implements Exception {
  /// create a instance of the [UnrecoverableException].
  ///
  /// [reason] why this exception was created.
  const UnrecoverableException(this.reason, this.exitCode);

  /// the reason why we can recover from this exception.
  final String reason;

  /// The exit code of the process.
  final int exitCode;

  @override
  String toString() => 'Exit code: $exitCode, Reason: $reason';
}
