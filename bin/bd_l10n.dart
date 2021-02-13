/*
 * The Clear BSD License
 *
 * Copyright (c) 2021 Bitsy Darel
 * All rights reserved.
 */

import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:bd_l10n/bd_l10n.dart';
import 'package:io/io.dart';
import 'package:path/path.dart' as path;

Future<void> main(List<String> arguments) async {
  ArgResults argResults;

  try {
    argResults = argumentParser.parse(arguments);
  } on Exception catch (_) {
    printHelpMessage('Invalid parameter specified.');
    exitCode = ExitCode.config.code;
    return;
  }

  if (argResults.wasParsed(helpArgument)) {
    printHelpMessage();
    exitCode = 0;
    return;
  }

  final File errorFile = File('.${utilityName}_error.txt');

  await runZonedGuarded<Future<void>>(
    () async {
      // delete any previous error file on new run.
      if (errorFile.existsSync()) {
        errorFile.deleteSync();
      }

      final File configFile = argResults.asConfigFile();

      final bool isFileWatcherEnabled = argResults.asFileWatcherFlag();

      final Directory projectDir = argResults.asProjectDir();

      final Configuration config = Configuration.fromYaml(
        configFile,
        projectDirPath: projectDir.path,
      );

      await config.generateLocalizations();

      final LocalizationWatcher watcher = config.watcher(configFile.path);

      if (isFileWatcherEnabled) {
        await watcher.startWatch();
      } else {
        await watcher.stopWatch();
      }
    },
    (Object error, StackTrace stack) {
      if (error is UnrecoverableException) {
        printHelpMessage(error.reason);
        exitCode = error.exitCode;
      } else {
        printHelpMessage(error.toString());
        exitCode = ExitCode.software.code;
      }

      errorFile.writeAsStringSync(error.toString());
    },
  );
}

extension _ArgResultsExtension on ArgResults {
  File asConfigFile() {
    final UnrecoverableException ue = UnrecoverableException(
      '--$configFileArgument argument is required',
      ExitCode.config.code,
    );

    // fail if the project type was not provided
    if (!wasParsed(configFileArgument)) {
      throw ue;
    }

    final dynamic rawConfigFile = this[configFileArgument];

    if (rawConfigFile is String && rawConfigFile.isNotEmpty) {
      final File configFile = File(rawConfigFile);

      if (!configFile.existsSync()) {
        throw UnrecoverableException(
          'Config File $rawConfigFile does not exit',
          ExitCode.config.code,
        );
      }

      return configFile;
    } else {
      throw ue;
    }
  }

  Directory asProjectDir() {
    if (rest.length != 1) {
      throw UnrecoverableException(
        'Local project dir path is required',
        ExitCode.config.code,
      );
    }

    final Directory projectDir = Directory(path.canonicalize(rest[0]));

    if (!projectDir.existsSync()) {
      throw UnrecoverableException(
        'Specified local project dir does not exist',
        ExitCode.config.code,
      );
    }

    return projectDir;
  }

  bool asFileWatcherFlag() {
    final dynamic fileWatcherEnabled = this[enableFileWatcher];

    if (fileWatcherEnabled is bool) {
      return fileWatcherEnabled;
    } else {
      throw UnrecoverableException(
        '$enableFileWatcher is required',
        ExitCode.usage.code,
      );
    }
  }
}
