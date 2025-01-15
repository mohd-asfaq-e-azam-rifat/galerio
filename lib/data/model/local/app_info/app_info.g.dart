// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppInfo _$AppInfoFromJson(Map<String, dynamic> json) => AppInfo(
      appName: json['app_name'] as String?,
      packageName: json['package_name'] as String?,
      versionName: json['version_name'] as String?,
      versionCode: json['version_code'] as String?,
      appFlavor: $enumDecodeNullable(_$AppFlavorEnumMap, json['app_flavor']),
      baseUrl: json['base_url'] as String?,
      platform: $enumDecodeNullable(_$TargetPlatformEnumMap, json['platform']),
      deviceModel: json['device_model'] as String?,
      deviceId: json['device_id'] as String?,
      manufacturer: json['manufacturer'] as String?,
      platformVersion: json['platform_version'] as String?,
      userAgent: json['user_agent'] as String?,
      buildType: $enumDecodeNullable(_$BuildTypeEnumMap, json['build_type']),
    );

Map<String, dynamic> _$AppInfoToJson(AppInfo instance) => <String, dynamic>{
      'app_name': instance.appName,
      'package_name': instance.packageName,
      'app_flavor': _$AppFlavorEnumMap[instance.appFlavor],
      'build_type': _$BuildTypeEnumMap[instance.buildType],
      'base_url': instance.baseUrl,
      'device_model': instance.deviceModel,
      'device_id': instance.deviceId,
      'manufacturer': instance.manufacturer,
      'user_agent': instance.userAgent,
      'version_name': instance.versionName,
      'version_code': instance.versionCode,
      'platform': _$TargetPlatformEnumMap[instance.platform],
      'platform_version': instance.platformVersion,
    };

const _$AppFlavorEnumMap = {
  AppFlavor.development: 'dev',
  AppFlavor.production: 'prod',
};

const _$TargetPlatformEnumMap = {
  TargetPlatform.android: 'android',
  TargetPlatform.fuchsia: 'fuchsia',
  TargetPlatform.iOS: 'iOS',
  TargetPlatform.linux: 'linux',
  TargetPlatform.macOS: 'macOS',
  TargetPlatform.windows: 'windows',
};

const _$BuildTypeEnumMap = {
  BuildType.debug: 'debug',
  BuildType.release: 'release',
};
