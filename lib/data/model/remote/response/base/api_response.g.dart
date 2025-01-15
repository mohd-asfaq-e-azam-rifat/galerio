// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ApiResponse<T>()
      ..code = json['code'] as String?
      ..message = json['message'] as String?
      ..data = _$nullableGenericFromJson(json['data'], fromJsonT)
      ..errors = json['errors'] == null
          ? null
          : Error.fromJson(json['errors'] as Map<String, dynamic>)
      ..status = (json['status'] as num?)?.toInt()
      ..timestamp = json['timestamp'] as String?
      ..error = json['error'] as String?
      ..path = json['path'] as String?
      ..expiredIn = json['expired_in'] as String?;

Map<String, dynamic> _$ApiResponseToJson<T>(
  ApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': _$nullableGenericToJson(instance.data, toJsonT),
      'errors': instance.errors,
      'status': instance.status,
      'timestamp': instance.timestamp,
      'error': instance.error,
      'path': instance.path,
      'expired_in': instance.expiredIn,
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);

ErrorItem _$ErrorItemFromJson(Map<String, dynamic> json) => ErrorItem()
  ..message = json['message'] as String?
  ..pointer = json['pointer'] as String?;

Map<String, dynamic> _$ErrorItemToJson(ErrorItem instance) => <String, dynamic>{
      'message': instance.message,
      'pointer': instance.pointer,
    };

Error _$ErrorFromJson(Map<String, dynamic> json) => Error()
  ..description = json['description'] as String?
  ..details = (json['details'] as List<dynamic>?)
      ?.map((e) => ErrorItem.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$ErrorToJson(Error instance) => <String, dynamic>{
      'description': instance.description,
      'details': instance.details,
    };
