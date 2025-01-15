import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galerio/base/app_config/app_config_event.dart';
import 'package:galerio/base/app_config/app_config_state.dart';
import 'package:galerio/base/helper/async.dart';
import 'package:galerio/base/state/basic/basic_state.dart';
import 'package:galerio/data/repository/auth_repository.dart';
import 'package:galerio/data/repository/common_repository.dart';
import 'package:galerio/injection.dart';
import 'package:injectable/injectable.dart';

@injectable
class AppConfigBloc extends Bloc<AppConfigEvent, AppConfigState> {
  final CommonRepository _commonRepository;
  final AuthRepository _authRepository;

  AppConfigBloc(this._commonRepository, this._authRepository)
      : super(
          AppConfigState(
            locale: _commonRepository.getLanguage() ?? const Locale("en"),
            themeMode: _commonRepository.getThemeMode() ?? ThemeMode.light,
            authState: _authRepository.getUserAuthState(),
          ),
        ) {
    on<AppInitialDataRequested>(_onAppInitialDataRequested);
    on<UserAuthStateUpdated>(_onUserAuthStateUpdated);
  }

  Future<void> _onAppInitialDataRequested(
    AppConfigEvent event,
    Emitter<AppConfigState> emit,
  ) async {
    await configurePostDependencies();

    final savedLocale = _commonRepository.getLanguage();
    if (savedLocale == null) {
      await _commonRepository.storeLanguage(state.locale);
    }

    final themeMode = _commonRepository.getThemeMode();
    if (themeMode == null) {
      await _commonRepository.storeThemeMode(state.themeMode);
    }

    // This delay is intentional to show progress indicator animation
    await delay(milliseconds: 1000);

    emit(
      state.copyWith(
        uiState: UiState.successful,
        themeMode: themeMode,
        locale: savedLocale,
        authState: getUserAuthState(),
      ),
    );
  }

  Future<void> _onUserAuthStateUpdated(
    UserAuthStateUpdated event,
    Emitter<AppConfigState> emit,
  ) async {
    emit(
      state.copyWith(
        authState: getUserAuthState(),
      ),
    );
  }

  UserAuthState getUserAuthState() {
    return _authRepository.getUserAuthState();
  }
}
