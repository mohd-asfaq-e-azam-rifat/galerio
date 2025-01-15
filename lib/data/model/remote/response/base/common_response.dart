import 'package:json_annotation/json_annotation.dart';

part 'common_response.g.dart';

enum LinkType { in_app, in_app_browser, external_browser }

@JsonSerializable(fieldRename: FieldRename.snake)
class Link {
  @JsonKey(defaultValue: null)
  late String? type;

  @JsonKey(defaultValue: null)
  late String? label;

  @JsonKey(defaultValue: null)
  late String? icon;

  @JsonKey(defaultValue: null)
  late int? tier;

  @JsonKey(defaultValue: null)
  late bool? disabled;

  @JsonKey(defaultValue: null)
  late bool? authRequire;

  @JsonKey(defaultValue: null)
  late String? color;

  @JsonKey(defaultValue: null)
  late LinkType? redirectType;

  @JsonKey(defaultValue: null)
  late String? url;

  @JsonKey(defaultValue: null)
  late bool? backstack;

  Link();

  factory Link.fromJson(Map<String, dynamic> json) => _$LinkFromJson(json);

  Map<String, dynamic> toJson() => _$LinkToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ImageSet {
  @JsonKey(defaultValue: null)
  late String? size;

  @JsonKey(defaultValue: null)
  late String? path;

  ImageSet();

  factory ImageSet.fromJson(Map<String, dynamic> json) =>
      _$ImageSetFromJson(json);

  Map<String, dynamic> toJson() => _$ImageSetToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Token {
  @JsonKey(defaultValue: null)
  late String? token;

  @JsonKey(defaultValue: null)
  late int? expire;

  Token();

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);

  Map<String, dynamic> toJson() => _$TokenToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class RangeLimit {
  @JsonKey(defaultValue: null)
  late int? min;

  @JsonKey(defaultValue: null)
  late int? max;

  RangeLimit();

  factory RangeLimit.fromJson(Map<String, dynamic> json) =>
      _$RangeLimitFromJson(json);

  Map<String, dynamic> toJson() => _$RangeLimitToJson(this);
}
