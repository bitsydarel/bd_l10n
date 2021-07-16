/*
 * The Clear BSD License
 *
 * Copyright (c) 2021 Bitsy Darel
 * All rights reserved.
 */

import 'dart:async';
import 'dart:io';

import 'package:bd_l10n/src/configuration.dart';
import 'package:bd_l10n/src/feature_configuration.dart';
import 'package:bd_l10n/src/localization_watcher.dart';
import 'package:bd_l10n/src/utils.dart';
import 'package:io/io.dart';
import 'package:path/path.dart' as path;
import 'package:watcher/watcher.dart';

const Duration _pollingDuration = Duration(minutes: 1);
const String _lockFileExtension = '.lock';

/// [LocalizationWatcher] that watch for localization changes and keep tracking
/// of watch event in a lock file [_lockFileName].
class FileLocalizationWatcher extends LocalizationWatcher {
  final Map<String, StreamSubscription<WatchEvent>> _watcherTracker =
      <String, StreamSubscription<WatchEvent>>{};

  /// The lock that track the end of file watcher.
  final Completer<void> _lock = Completer<void>();

  /// The lock file used to track the watcher status.
  final String _lockFileName;

  /// [utilityName] configuration file location.
  final String configFileLocation;

  /// Create [FileLocalizationWatcher] with the specified parameters.
  ///
  /// [configuration] to use with the [FileLocalizationWatcher].
  ///
  /// [startedAt] when the [FileLocalizationWatcher] started watching watching
  /// files.
  ///
  /// [lockFileName] to use as lock.
  FileLocalizationWatcher({
    required this.configFileLocation,
    required Configuration configuration,
    required DateTime startedAt,
    String? lockFileName,
  })  : _lockFileName = lockFileName ??
            '.${utilityName}_'
                '${startedAt.millisecondsSinceEpoch}$_lockFileExtension',
        super(configuration);

  @override
  Future<void> startWatch() async {
    // Stop any previous file watch that is in progress in the current project.
    await stopWatch();

    final String configDir = path.dirname(configFileLocation);

    // create lock file in the same dire as config file.
    final File lockFile = File(
      '${path.canonicalize(configDir)}/$_lockFileName',
    );

    // Track file changes in the lock file, so we can stop file watcher
    // if user delete lock file on purpose or as trigger.
    _trackFileChanges(lockFile.path, lockFile, shouldLogEvent: false);

    _writeToFile(
      lockFile,
      'Starting watch for file system events '
      'at ${DateTime.now().toIso8601String()}',
    );

    // Track configuration file for changes so we can regenerate localizations.
    _trackFileChanges(configFileLocation, lockFile);

    _writeToFile(lockFile, 'Watching file $configFileLocation');

    for (final FeatureConfiguration feature in configuration.features) {
      final String dirFullPath = path.canonicalize(
        path.join(configuration.projectDirPath, feature.translationDirPath),
      );

      final String fileFullPath = path.canonicalize(
        path.join(dirFullPath, feature.translationTemplateFileName),
      );

      // Track changes in directory so we can generate build on new arb files.
      _trackTranslationDirectoryChanges(dirFullPath, fileFullPath, lockFile);

      _writeToFile(lockFile, 'Watching directory $dirFullPath');
    }

    // Wait until file watch is terminated or cancelled
    await _lock.future;

    // If lock complete/release we can delete the lock file.
    // file can be deleted if user, deleted the file.
    if (lockFile.existsSync()) {
      lockFile.deleteSync();
    }
  }

  @override
  Future<void> stopWatch() async {
    final Directory configDir = Directory(path.dirname(configFileLocation));

    for (final FileSystemEntity entity in configDir.listSync()) {
      final String name = path.basename(entity.path);

      if (name.contains(utilityName) && name.endsWith(_lockFileExtension)) {
        entity.deleteSync();
      }
    }
  }

  void _trackFileChanges(
    final String filePath,
    final File logFile, {
    bool shouldLogEvent = true,
  }) {
    _watcherTracker[filePath] = FileWatcher(
      filePath,
      pollingDelay: _pollingDuration, // ignored if system support.
    ).events.listen(
      (WatchEvent event) {
        final String fileName = path.basename(filePath);

        switch (event.type) {
          case ChangeType.ADD:
          case ChangeType.MODIFY:
            final File configFile = File(configFileLocation);
            Configuration.fromYaml(
              configFile,
              projectDirPath: configuration.projectDirPath,
            ).generateLocalizations();

            if (fileName == configFileLocation) {
              // reset the watch
              startWatch();
            }
            break;
          case ChangeType.REMOVE:
            _onDeleteEvent(filePath, event);

            if (fileName == _lockFileName) {
              // if lock file is deleted stop watcher.
              _cancelTrackers();
            }

            if (fileName == configFileLocation) {
              final String errorMessage = 'config file: $configFileLocation '
                  'was deleted but watch stop was not requested';

              _cancelTrackers();
              _writeToFile(logFile, errorMessage);
              throw UnrecoverableException(errorMessage, ExitCode.usage.code);
            }
            break;
        }

        if (shouldLogEvent) {
          _writeToFile(logFile, event.toString());
        }
      },
      cancelOnError: true,
    );
  }

  void _trackTranslationDirectoryChanges(
    final String translationDirectoryPath,
    final String translationTemplatePath,
    final File logFile,
  ) {
    _watcherTracker[translationDirectoryPath] = DirectoryWatcher(
      translationDirectoryPath,
      pollingDelay: _pollingDuration, // ignored if system support.
    ).events.listen(
      (WatchEvent event) {
        switch (event.type) {
          case ChangeType.ADD:
          case ChangeType.MODIFY:
            _generateLocalizations(configFileLocation);
            break;
          case ChangeType.REMOVE:
            if (event.path == translationTemplatePath) {
              _onTranslationTemplateDeleted(
                translationDirectoryPath,
                translationTemplatePath,
                event,
                logFile,
              );
            } else if (event.path == translationDirectoryPath) {
              _onTranslationDirectoryDeleted(
                translationDirectoryPath,
                event,
                logFile,
              );
            } else {
              _generateLocalizations(configFileLocation);
            }

            if (_watcherTracker.isEmpty) {
              _onWatcherEmpty(logFile);
            }
            break;
        }

        // log event so user will have history of what's happening.
        _writeToFile(logFile, event.toString());
      },
      cancelOnError: true,
    );
  }

  void _onTranslationDirectoryDeleted(
    final String translationDirPath,
    final WatchEvent event,
    final File logFile,
  ) {
    _onDeleteEvent(translationDirPath, event);

    _writeToFile(
      logFile,
      'translation-dir: $translationDirPath was deleted\n'
      'Stopping translation-dir watch for $translationDirPath',
    );
  }

  void _onTranslationTemplateDeleted(
    final String translationDirPath,
    final String translationTemplate,
    final WatchEvent event,
    final File logFile,
  ) {
    _onDeleteEvent(translationDirPath, event);

    _writeToFile(
      logFile,
      'translation-template: $translationTemplate was deleted\n'
      'Stopping translation-dir watch for $translationDirPath',
    );
  }

  void _onWatcherEmpty(final File logFile) {
    const String errorWatcher = 'No translation directory/template left to '
        'watch, but watch stop was not requested, exiting $utilityName';

    _writeToFile(logFile, errorWatcher);

    throw UnrecoverableException(errorWatcher, ExitCode.usage.code);
  }

  void _onDeleteEvent(final String watchedPath, final WatchEvent event) {
    final StreamSubscription<WatchEvent>? watcher = _watcherTracker.remove(
      watchedPath,
    );

    watcher?.cancel();
  }

  void _cancelTrackers() {
    final List<Future<void>> actions = <Future<void>>[];

    _watcherTracker.values.forEach(
      (StreamSubscription<WatchEvent> watcher) => actions.add(
        watcher.cancel(),
      ),
    );

    Future.wait(actions).whenComplete(() => _lock.complete(null));
  }

  void _generateLocalizations(final String configFilePath) {
    final File configFile = File(configFilePath);

    Configuration.fromYaml(
      configFile,
      projectDirPath: configuration.projectDirPath,
    ).generateLocalizations();
  }
}

void _writeToFile(final File file, final String message) {
  file.writeAsStringSync(
    '$message\n',
    mode: FileMode.writeOnlyAppend,
    flush: true,
  );

  stdout.writeln(message);
}
