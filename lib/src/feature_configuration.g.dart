/*
 * The Clear BSD License
 *
 * Copyright (c) 2021 Bitsy Darel
 * All rights reserved.
 */

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeatureConfiguration _$FeatureConfigurationFromJson(Map json) {
  return $checkedNew('FeatureConfiguration', json, () {
    $checkKeys(json, allowedKeys: const [
      'name',
      'translation-dir',
      'translation-template',
      'output-dir',
      'use-deferred-loading'
    ], requiredKeys: const [
      'name',
      'translation-dir',
      'translation-template'
    ], disallowNullValues: const [
      'name',
      'translation-dir',
      'translation-template',
      'output-dir',
      'use-deferred-loading'
    ]);
    final val = FeatureConfiguration(
      name: $checkedConvert(json, 'name', (v) => v as String),
      translationTemplateFileName:
          $checkedConvert(json, 'translation-template', (v) => v as String),
      translationDirPath:
          $checkedConvert(json, 'translation-dir', (v) => v as String),
      outputDirPath: $checkedConvert(json, 'output-dir', (v) => v as String),
      useDeferredLoading:
          $checkedConvert(json, 'use-deferred-loading', (v) => v as bool),
    );
    return val;
  }, fieldKeyMap: const {
    'translationTemplateFileName': 'translation-template',
    'translationDirPath': 'translation-dir',
    'outputDirPath': 'output-dir',
    'useDeferredLoading': 'use-deferred-loading'
  });
}

Map<String, dynamic> _$FeatureConfigurationToJson(
    FeatureConfiguration instance) {
  final val = <String, dynamic>{
    'name': instance.name,
    'translation-dir': instance.translationDirPath,
    'translation-template': instance.translationTemplateFileName,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('output-dir', instance.outputDirPath);
  writeNotNull('use-deferred-loading', instance.useDeferredLoading);
  return val;
}
