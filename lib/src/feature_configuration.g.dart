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

FeatureConfiguration _$FeatureConfigurationFromJson(Map json) => $checkedCreate(
      'FeatureConfiguration',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const [
            'name',
            'translation-dir',
            'translation-template',
            'output-dir',
            'use-deferred-loading'
          ],
          requiredKeys: const [
            'name',
            'translation-dir',
            'translation-template'
          ],
          disallowNullValues: const [
            'name',
            'translation-dir',
            'translation-template',
            'output-dir',
            'use-deferred-loading'
          ],
        );
        final val = FeatureConfiguration(
          name: $checkedConvert('name', (v) => v as String),
          translationTemplateFileName:
              $checkedConvert('translation-template', (v) => v as String),
          translationDirPath:
              $checkedConvert('translation-dir', (v) => v as String),
          outputDirPath: $checkedConvert('output-dir', (v) => v as String),
          useDeferredLoading:
              $checkedConvert('use-deferred-loading', (v) => v as bool?),
        );
        return val;
      },
      fieldKeyMap: const {
        'translationTemplateFileName': 'translation-template',
        'translationDirPath': 'translation-dir',
        'outputDirPath': 'output-dir',
        'useDeferredLoading': 'use-deferred-loading'
      },
    );

Map<String, dynamic> _$FeatureConfigurationToJson(
        FeatureConfiguration instance) =>
    <String, dynamic>{
      'name': instance.name,
      'translation-dir': instance.translationDirPath,
      'translation-template': instance.translationTemplateFileName,
      'output-dir': instance.outputDirPath,
      'use-deferred-loading': instance.useDeferredLoading,
    };
