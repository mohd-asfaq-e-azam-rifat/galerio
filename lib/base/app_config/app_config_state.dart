import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:galerio/base/state/basic/basic_state.dart';

class AppConfigState extends Equatable {
  static final GlobalKey<NavigatorState> appKey = GlobalKey<NavigatorState>();

  final Locale locale;
  final ThemeMode themeMode;
  final UserAuthState authState;
  final UiState uiState;
  final String? message;

  const AppConfigState({
    required this.locale,
    required this.themeMode,
    this.authState = UserAuthState.unauthorized,
    this.uiState = UiState.initial,
    this.message,
  });

  AppConfigState copyWith({
    Locale? locale,
    String? message,
    UserAuthState? authState,
    UiState? uiState,
    ThemeMode? themeMode,
  }) {
    return AppConfigState(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      authState: authState ?? this.authState,
      uiState: uiState ?? this.uiState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        locale,
        themeMode,
        authState,
        uiState,
        message,
      ];
}
