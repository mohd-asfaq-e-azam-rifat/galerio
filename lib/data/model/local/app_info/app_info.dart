import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_info.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AppInfo {
  @JsonKey(defaultValue: null)
  late String? appName;

  @JsonKey(defaultValue: null)
  late String? packageName;

  @JsonKey(defaultValue: null)
  late AppFlavor? appFlavor;

  @JsonKey(defaultValue: null)
  late BuildType? buildType;

  @JsonKey(defaultValue: null)
  late String? baseUrl;

  @JsonKey(defaultValue: null)
  late String? deviceModel;

  @JsonKey(defaultValue: null)
  late String? deviceId;

  @JsonKey(defaultValue: null)
  late String? manufacturer;

  @JsonKey(defaultValue: null)
  late String? userAgent;

  @JsonKey(defaultValue: null)
  late String? versionName;

  @JsonKey(defaultValue: null)
  late String? versionCode;

  @JsonKey(defaultValue: null)
  late TargetPlatform? platform;

  @JsonKey(defaultValue: null)
  late String? platformVersion;

  AppInfo({
    this.appName,
    this.packageName,
    this.versionName,
    this.versionCode,
    this.appFlavor,
    this.baseUrl,
    this.platform,
    this.deviceModel,
    this.deviceId,
    this.manufacturer,
    this.platformVersion,
    this.userAgent,
    this.buildType,
  });

  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return _$AppInfoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AppInfoToJson(this);
  }

  bool isDebugBuild() {
    return buildType == BuildType.debug;
  }
}

enum AppFlavor {
  @JsonValue("dev")
  development("dev"),
  @JsonValue("prod")
  production("prod");

  const AppFlavor(this.value);

  final String value;
}

enum BuildType {
  @JsonValue("debug")
  debug,
  @JsonValue("release")
  release,
}
