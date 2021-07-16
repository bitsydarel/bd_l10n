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
              'project-type', (v) => _$enumDecode(_$ProjectTypeEnumMap, v)),
          features: $checkedConvert(
              'features',
              (v) => (v as List<dynamic>)
                  .map((e) => FeatureConfiguration.fromJson(e as Map))
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
      'project-type': _$ProjectTypeEnumMap[instance.projectType],
      'project-dir-path': instance.projectDirPath,
      'features': instance.features,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$ProjectTypeEnumMap = {
  ProjectType.flutter: 'flutter',
};
