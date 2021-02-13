/*
 * The Clear BSD License
 *
 * Copyright (c) 2021 Bitsy Darel
 * All rights reserved.
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'feature_configuration.g.dart';

/// Localization Feature Configuration.
@JsonSerializable(
  anyMap: true,
  disallowUnrecognizedKeys: true,
  checked: true,
)
class FeatureConfiguration {
  static final RegExp _nameValidator = RegExp(
    "^(?=[A-Za-z]+[_ ]*[A-Za-z]*)(?!.*[@'#%^=+!:;?()\"]).*",
  );

  /// Name of the feature.
  @JsonKey(disallowNullValue: true, required: true, nullable: false)
  final String name;

  /// The directory where the template and translated files are located.
  @JsonKey(
    name: 'translation-dir',
    disallowNullValue: true,
    nullable: false,
    required: true,
  )
  final String translationDirPath;

  /// The template localization file that will be used as the basis for
  /// generating the Dart localization and messages classes.
  @JsonKey(
    name: 'translation-template',
    disallowNullValue: true,
    nullable: false,
    required: true,
  )
  final String translationTemplateFileName;

  /// The directory where the generated localization classes will be written.
  @JsonKey(
    name: 'output-dir',
    disallowNullValue: true,
    nullable: true,
  )
  final String outputDirPath;

  ///  Whether to generate the Dart localization file with locales imported
  ///  as deferred, allowing for lazy loading of each locale in Flutter web.
  @JsonKey(
    name: 'use-deferred-loading',
    disallowNullValue: true,
    nullable: true,
  )
  final bool useDeferredLoading;

  /// Create feature with all the required field.
  FeatureConfiguration({
    @required this.name,
    @required this.translationTemplateFileName,
    @required this.translationDirPath,
    @required this.outputDirPath,
    bool useDeferredLoading,
  }) : useDeferredLoading = useDeferredLoading ?? false {
    if (name == null || !_nameValidator.hasMatch(name)) {
      throw ArgumentError.value(
        name,
        'name',
        'Should match the following Regex ${_nameValidator.pattern}',
      );
    }

    if (translationTemplateFileName == null ||
        translationTemplateFileName.trim().isEmpty == true) {
      throw ArgumentError.value(
        translationTemplateFileName,
        'translation template file',
        'Should be specified',
      );
    }

    if (translationDirPath == null ||
        translationDirPath.trim().isEmpty == true) {
      throw ArgumentError.value(
        translationDirPath,
        'translation directory path',
        'Should be specified',
      );
    }

    if (outputDirPath == null || outputDirPath.trim().isEmpty == true) {
      throw ArgumentError.value(
        outputDirPath,
        'output-dir',
        'Should be specified',
      );
    }
  }

  /// Create a [FeatureConfiguration] from [json] representation.
  factory FeatureConfiguration.fromJson(Map<Object, Object> json) =>
      _$FeatureConfigurationFromJson(json);

  /// Convert a [FeatureConfiguration] to json representation.
  Map<String, Object> toJson() => _$FeatureConfigurationToJson(this);

  @override
  String toString() => 'FeatureConfiguration: ${toJson()}';
}
