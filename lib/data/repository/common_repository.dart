import 'package:flutter/material.dart';
import 'package:galerio/data/service/local/common_local_service.dart';
import 'package:galerio/data/service/remote/common_remote_service.dart';
import 'package:injectable/injectable.dart';

@injectable
@singleton
class CommonRepository {
  final CommonLocalService _localService;
  final CommonRemoteService _remoteService;

  CommonRepository(this._localService, this._remoteService);

  Future<bool> isFirstTimeUser() async {
    final bool flag = _localService.isFirstTimeUser();
    if (flag == true) {
      await _localService.flagOldUser();
    }

    return flag;
  }

  Future<void> storeLanguage(Locale locale) {
    return _localService.storeLanguage(locale);
  }

  Locale? getLanguage() {
    return _localService.getLanguage();
  }

  Future<void> storeThemeMode(ThemeMode themeMode) {
    return _localService.storeThemeMode(themeMode);
  }

  ThemeMode? getThemeMode() {
    return _localService.getThemeMode();
  }

  Future<void> storeDestinationAfterLogin(String destinationAfterLogin) {
    return _localService.storeDestinationAfterLogin(destinationAfterLogin);
  }

  Future<String?> getDestinationAfterLogin() async {
    final destination = _localService.getDestinationAfterLogin();
    await _localService.clearDestinationAfterLogin();
    return destination;
  }
}
