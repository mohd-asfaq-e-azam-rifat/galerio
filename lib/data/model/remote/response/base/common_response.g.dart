// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Link _$LinkFromJson(Map<String, dynamic> json) => Link()
  ..type = json['type'] as String?
  ..label = json['label'] as String?
  ..icon = json['icon'] as String?
  ..tier = (json['tier'] as num?)?.toInt()
  ..disabled = json['disabled'] as bool?
  ..authRequire = json['auth_require'] as bool?
  ..color = json['color'] as String?
  ..redirectType = $enumDecodeNullable(_$LinkTypeEnumMap, json['redirect_type'])
  ..url = json['url'] as String?
  ..backstack = json['backstack'] as bool?;

Map<String, dynamic> _$LinkToJson(Link instance) => <String, dynamic>{
      'type': instance.type,
      'label': instance.label,
      'icon': instance.icon,
      'tier': instance.tier,
      'disabled': instance.disabled,
      'auth_require': instance.authRequire,
      'color': instance.color,
      'redirect_type': _$LinkTypeEnumMap[instance.redirectType],
      'url': instance.url,
      'backstack': instance.backstack,
    };

const _$LinkTypeEnumMap = {
  LinkType.in_app: 'in_app',
  LinkType.in_app_browser: 'in_app_browser',
  LinkType.external_browser: 'external_browser',
};

ImageSet _$ImageSetFromJson(Map<String, dynamic> json) => ImageSet()
  ..size = json['size'] as String?
  ..path = json['path'] as String?;

Map<String, dynamic> _$ImageSetToJson(ImageSet instance) => <String, dynamic>{
      'size': instance.size,
      'path': instance.path,
    };

Token _$TokenFromJson(Map<String, dynamic> json) => Token()
  ..token = json['token'] as String?
  ..expire = (json['expire'] as num?)?.toInt();

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
      'token': instance.token,
      'expire': instance.expire,
    };

RangeLimit _$RangeLimitFromJson(Map<String, dynamic> json) => RangeLimit()
  ..min = (json['min'] as num?)?.toInt()
  ..max = (json['max'] as num?)?.toInt();

Map<String, dynamic> _$RangeLimitToJson(RangeLimit instance) =>
    <String, dynamic>{
      'min': instance.min,
      'max': instance.max,
    };
