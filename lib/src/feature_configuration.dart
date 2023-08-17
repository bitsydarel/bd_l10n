/*
 * The Clear BSD License
 *
 * Copyright (c) 2021 Bitsy Darel
 * All rights reserved.
 */

import 'package:json_annotation/json_annotation.dart';

part 'feature_configuration.g.dart';

/// Localization Feature Configuration.
@JsonSerializable(
  disallowUnrecognizedKeys: true,
  checked: true,
  anyMap: true,
)
class FeatureConfiguration {
  static final RegExp _nameValidator = RegExp(
    "^(?=[A-Za-z]+[_ ]*[A-Za-z]*)(?!.*[@'#%^=+!:;?()\"]).*",
  );

  /// Name of the feature.
  @JsonKey(disallowNullValue: true, required: true)
  final String name;

  /// The directory where the template and translated files are located.
  @JsonKey(
    name: 'translation-dir',
    disallowNullValue: true,
    required: true,
  )
  final String translationDirPath;

  /// The template localization file that will be used as the basis for
  /// generating the Dart localization and messages classes.
  @JsonKey(
    name: 'translation-template',
    disallowNullValue: true,
    required: true,
  )
  final String translationTemplateFileName;

  /// The directory where the generated localization classes will be written.
  @JsonKey(
    name: 'output-dir',
    disallowNullValue: true,
  )
  final String outputDirPath;

  ///  Whether to generate the Dart localization file with locales imported
  ///  as deferred, allowing for lazy loading of each locale in Flutter web.
  @JsonKey(
    name: 'use-deferred-loading',
    disallowNullValue: true,
  )
  final bool useDeferredLoading;

  /// Create feature with all the required field.
  FeatureConfiguration({
    required this.name,
    required this.translationTemplateFileName,
    required this.translationDirPath,
    required this.outputDirPath,
    bool? useDeferredLoading,
  }) : useDeferredLoading = useDeferredLoading ?? false {
    if (!_nameValidator.hasMatch(name)) {
      throw ArgumentError.value(
        name,
        'name',
        'Should match the following Regex ${_nameValidator.pattern}',
      );
    }

    if (translationTemplateFileName.trim().isEmpty == true) {
      throw ArgumentError.value(
        translationTemplateFileName,
        'translation template file',
        'Should be specified',
      );
    }

    if (translationDirPath.trim().isEmpty == true) {
      throw ArgumentError.value(
        translationDirPath,
        'translation directory path',
        'Should be specified',
      );
    }

    if (outputDirPath.trim().isEmpty == true) {
      throw ArgumentError.value(
        outputDirPath,
        'output-dir',
        'Should be specified',
      );
    }
  }

  /// Create a [FeatureConfiguration] from [json] representation.
  factory FeatureConfiguration.fromJson(Map<Object, Object> json) {
    return _$FeatureConfigurationFromJson(json);
  }

  /// Convert a [FeatureConfiguration] to json representation.
  Map<String, Object?> toJson() {
    return _$FeatureConfigurationToJson(this);
  }

  @override
  String toString() => 'FeatureConfiguration: ${toJson()}';
}
