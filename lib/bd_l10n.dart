/*
 * The Clear BSD License
 *
 * Copyright (c) 2021 Bitsy Darel
 * All rights reserved.
 */

library bd_l10n;

import 'dart:async';
import 'dart:io';

import 'package:bd_l10n/src/utils.dart';
import 'package:build/build.dart';
import 'package:path/path.dart' as path;

export 'package:bd_l10n/src/utils.dart';
export 'package:bd_l10n/src/configuration.dart';
export 'package:bd_l10n/src/localization_watcher.dart';

/// Top level function to create code generation builder.
Builder bdL10nToBuilder(BuilderOptions options) => _BDL10n();

class _BDL10n extends Builder {
  @override
  Map<String, List<String>> get buildExtensions {
    return const <String, List<String>>{
      '.yaml': <String>['.log'],
    };
  }

  @override
  FutureOr<void> build(final BuildStep buildStep) {
    final String configFilePath = _foundConfigFile();

    if (configFilePath == null) {
      log.warning(
        'Config file not found in project, '
        'please create a $configFilePath file',
      );
    } else {
      final bool isConfigFileUnderLib = _isUnderLib(configFilePath);

      final String buildTriggerFilePath = buildStep.inputId.pathSegments.last;

      //If config file is not under lib, build runner won't include it as asset.
      if (!isConfigFileUnderLib || configFileName == buildTriggerFilePath) {
        final File configFile = File(configFilePath);

        Process.start(
          'flutter',
          <String>[
            'pub',
            'run',
            'bd_l10n',
            '--$configFileArgument',
            configFile.path,
            '.',
          ],
          runInShell: true,
          mode: ProcessStartMode.detached,
        );

        stdout
          ..writeln('bd_l10n script launched in background')
          ..writeln(
            'Will automatically generate translation files when '
            '${configFile.path} changes or one of the arb files changes',
          )
          ..writeln('To stop $utilityName delete ${utilityName}_*.lock');

        buildStep.writeAsString(
          buildStep.inputId.changeExtension('.log'),
          DateTime.now().toIso8601String(),
        );
      }
    }
  }

  static String _foundConfigFile() {
    final List<FileSystemEntity> entities =
        Directory.current.listSync(recursive: true);

    for (final FileSystemEntity entity in entities) {
      final String filename = path.basename(entity.path);

      if (configFileName == filename) {
        return entity.absolute.path;
      }
    }

    return null;
  }

  static bool _isUnderLib(final String filePath) {
    final String rootDir = Directory.current.path;

    final Directory libFolder = Directory('$rootDir/lib');

    if (!libFolder.existsSync()) {
      return false;
    }

    for (final FileSystemEntity entity in libFolder.listSync(recursive: true)) {
      final String fileNameEntity = path.basename(entity.path);
      final String filename = path.basename(filePath);

      if (fileNameEntity == filename) {
        return true;
      }
    }

    return false;
  }
}
