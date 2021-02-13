/*
 * The Clear BSD License
 *
 * Copyright (c) 2021 Bitsy Darel
 * All rights reserved.
 */

import 'dart:io';

import 'package:bd_l10n/src/utils.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as path;
import 'package:bd_l10n/src/feature_configuration.dart';

part 'configuration.g.dart';

/// BD L10n configuration representation.
@JsonSerializable(
  anyMap: true,
  disallowUnrecognizedKeys: true,
  checked: true,
  nullable: false,
)
class Configuration {
  /// Project type that [utilityName] is being used for.
  @JsonKey(name: 'project-type', disallowNullValue: true, required: true)
  final ProjectType projectType;

  /// Project dir path of this [utilityName].
  @JsonKey(name: 'project-dir-path', disallowNullValue: true, required: false)
  final String projectDirPath;

  /// Localization Features used in this project.
  @JsonKey(disallowNullValue: true, required: true)
  final List<FeatureConfiguration> features;

  /// Create a [Configuration] with the [projectType] list of [features] and
  /// [projectDirPath].
  Configuration({
    @required this.projectType,
    @required this.features,
    String projectDirPath,
  }) : projectDirPath = projectDirPath ?? Directory.current.path {
    if (projectType == null) {
      throw ArgumentError.value(
        projectType,
        'project type',
        'Need to be specified',
      );
    }

    if (this.projectDirPath == null || this.projectDirPath.isEmpty == true) {
      throw ArgumentError.value(
        projectDirPath,
        'Project dir path',
        'Need to be specified',
      );
    }

    if (features == null || features.isEmpty == true) {
      throw ArgumentError.value(
        features,
        'features',
        'At least one feature need to be specified',
      );
    }
  }

  /// Create a [Configuration] from [yamlFile].
  factory Configuration.fromYaml(
    final File yamlFile, {
    String projectDirPath,
  }) {
    final String yamlPath = yamlFile.path;

    if (!yamlFile.existsSync()) {
      throw ArgumentError('${path.basename(yamlPath)} does not exist');
    }

    final String yamlContent = yamlFile.readAsStringSync();

    if (yamlContent.trim().isEmpty) {
      throw ArgumentError('${path.basename(yamlPath)} is empty');
    }

    try {
      final Object parseYamlContent = loadYaml(
        yamlContent,
        sourceUrl: yamlPath,
      );

      final Configuration configuration = Configuration.fromJson(
        parseYamlContent is Map
            ? parseYamlContent
            : throw ArgumentError('Config file content is invalid'),
      );

      return Configuration(
        projectType: configuration.projectType,
        features: configuration.features,
        projectDirPath: projectDirPath ?? configuration.projectDirPath,
      );
    } on CheckedFromJsonException catch (e) {
      final List<String> errorMessage = <String>[
        if (e.className != null) 'Could not create `${e.className}`.',
        if (e.key != null) 'There is a problem with "${e.key}".',
        if (e.message != null) e.message
      ];

      throw ArgumentError(errorMessage.join('\n'));
    } on YamlException catch (e) {
      throw ArgumentError(e.message);
    }
  }

  /// Create [Configuration] from [json] representation.
  factory Configuration.fromJson(Map<Object, Object> json) =>
      _$ConfigurationFromJson(json);

  /// Convert [Configuration] to a json representation.
  Map<String, dynamic> toJson() => _$ConfigurationToJson(this);

  @override
  String toString() => 'Configuration: ${toJson()}';
}

/// List of project type supported by [utilityName].
enum ProjectType {
  /// Flutter project type.
  @JsonValue('flutter')
  flutter,
}
