/*
 * The Clear BSD License
 *
 * Copyright (c) 2021 Bitsy Darel
 * All rights reserved.
 */

import 'dart:io';

import 'package:bd_l10n/src/configuration.dart';
import 'package:bd_l10n/src/feature_configuration.dart';
import 'package:bd_l10n/src/localization_builder.dart';
import 'package:bd_l10n/src/name_formatter.dart';
import 'package:bd_l10n/src/utils.dart';
import 'package:io/io.dart';
import 'package:path/path.dart' as path;

/// [LocalizationBuilder] for flutter project.
class FlutterLocalizationBuilder extends LocalizationBuilder {
  /// Create a [FlutterLocalizationBuilder] with [configuration]
  /// and [nameFormatter].
  const FlutterLocalizationBuilder(
    Configuration configuration,
    NameFormatter nameFormatter,
  ) : super(configuration, nameFormatter);

  @override
  Future<void> build() async {
    for (final FeatureConfiguration feature in configuration.features) {
      await _buildForFeature(feature);
      stdout.writeln('Generated localization for feature ${feature.name}');
    }
  }

  Future<void> _buildForFeature(final FeatureConfiguration feature) async {
    final String localizationFileName =
        await nameFormatter.getLocalizationFileName(feature);

    final String localizationClassName =
        await nameFormatter.getLocalizationClassName(feature);

    final ProcessResult result = Process.runSync(
      'flutter',
      <String>[
        'gen-l10n',
        '--project-dir',
        configuration.projectDirPath,
        '--template-arb-file',
        feature.translationTemplateFileName,
        '--arb-dir',
        path.join(configuration.projectDirPath, feature.translationDirPath),
        '--no-synthetic-package',
        '--output-dir',
        path.join(configuration.projectDirPath, feature.outputDirPath),
        '--output-localization-file',
        localizationFileName,
        '--output-class',
        localizationClassName,
        if (feature.useDeferredLoading) '--use-deferred-loading'
      ],
      runInShell: Platform.isWindows,
    );

    final String errorMessage = result.stderr.toString();

    final String outputMessage = result.stdout.toString();

    if (result.exitCode != ExitCode.success.code || errorMessage.isNotEmpty) {
      final String fullMessage = '$errorMessage\n$outputMessage';

      throw UnrecoverableException(fullMessage, result.exitCode);
    }

    stdout.writeln(outputMessage + errorMessage);
  }
}
