/*
 * The Clear BSD License
 *
 * Copyright (c) 2021 Bitsy Darel
 * All rights reserved.
 */

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Configuration _$ConfigurationFromJson(Map json) => $checkedCreate(
      'Configuration',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['project-type', 'project-dir-path', 'features'],
          requiredKeys: const ['project-type', 'features'],
          disallowNullValues: const [
            'project-type',
            'project-dir-path',
            'features'
          ],
        );
        final val = Configuration(
          projectType: $checkedConvert(
              'project-type', (v) => $enumDecode(_$ProjectTypeEnumMap, v)),
          features: $checkedConvert(
              'features',
              (v) => (v as List<dynamic>)
                  .map((e) => FeatureConfiguration.fromJson((e as Map).map(
                        (k, e) => MapEntry(k as Object, e as Object),
                      )))
                  .toList()),
          projectDirPath:
              $checkedConvert('project-dir-path', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'projectType': 'project-type',
        'projectDirPath': 'project-dir-path'
      },
    );

Map<String, dynamic> _$ConfigurationToJson(Configuration instance) =>
    <String, dynamic>{
      'project-type': _$ProjectTypeEnumMap[instance.projectType]!,
      'project-dir-path': instance.projectDirPath,
      'features': instance.features,
    };

const _$ProjectTypeEnumMap = {
  ProjectType.flutter: 'flutter',
};
