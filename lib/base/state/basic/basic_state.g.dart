// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basic_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BasicState _$BasicStateFromJson(Map<String, dynamic> json) => BasicState(
      uiState: $enumDecodeNullable(_$UiStateEnumMap, json['ui_state']) ??
          UiState.initial,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$BasicStateToJson(BasicState instance) =>
    <String, dynamic>{
      'ui_state': _$UiStateEnumMap[instance.uiState]!,
      'message': instance.message,
    };

const _$UiStateEnumMap = {
  UiState.initial: 'initial',
  UiState.loading: 'loading',
  UiState.successful: 'successful',
  UiState.error: 'error',
  UiState.empty: 'empty',
  UiState.cancelled: 'cancelled',
};
