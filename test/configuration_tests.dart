/*
 * The Clear BSD License
 *
 * Copyright (c) 2021 Bitsy Darel
 * All rights reserved.
 */

import 'dart:io';

import 'package:bd_l10n/src/configuration.dart';
import 'package:bd_l10n/src/feature_configuration.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Configuration.fromYaml',
    () {
      test(
        'Should parse configuration from yaml config',
        () {
          final File configFile = File(
            '${Directory.current.path}/test/resources/valid_bd_l10n.yaml',
          );

          final Configuration config = Configuration.fromYaml(configFile);

          expect(config, isA<Configuration>());

          expect(config.features, hasLength(equals(2)));

          expect(
            config.features.any((FeatureConfiguration feature) {
              return feature.name.isEmpty ||
                  feature.translationDirPath.isEmpty ||
                  feature.translationTemplateFileName.isEmpty ||
                  feature.outputDirPath.isEmpty;
            }),
            isFalse,
          );

          expect(
            config.features.where(
              (FeatureConfiguration feature) => feature.useDeferredLoading,
            ),
            hasLength(equals(1)),
          );
        },
      );

      test(
        'Should throw argument error when the file could not be found',
        () {
          expect(
            () => Configuration.fromYaml(File('bd_l10n.yaml')),
            throwsArgumentError,
          );
        },
      );

      test(
        'Should throw argument error when no configuration founded in file',
        () {
          final File configFile = File(
            '${Directory.current.path}/test/resources/empty_bd_l10n.yaml',
          );

          expect(() => Configuration.fromYaml(configFile), throwsArgumentError);
        },
      );

      test(
        'Should throw argument error if missing name',
        () {
          final String currentDirPath = Directory.current.path;

          final File configFile = File(
            '$currentDirPath/test/resources/missing_name_bd_l10n.yaml',
          );

          expect(() => Configuration.fromYaml(configFile), throwsArgumentError);
        },
      );

      test(
        'Should throw argument error if missing translation directory',
        () {
          final String currentDir = Directory.current.path;

          final File configFile = File(
            '$currentDir/test/resources/missing_translation_dir_bd_l10n.yaml',
          );

          expect(() => Configuration.fromYaml(configFile), throwsArgumentError);
        },
      );

      test(
        'Should throw argument error if missing translation directory',
        () {
          final String current = Directory.current.path;

          final File configFile = File(
            '$current/test/resources/missing_translation_template_bd_l10n.yaml',
          );

          expect(() => Configuration.fromYaml(configFile), throwsArgumentError);
        },
      );
    },
  );
}
