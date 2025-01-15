import 'package:flutter/material.dart';
import 'package:galerio/data/extensions.dart';
import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';

@injectable
@singleton
class CommonLocalService {
  // keys
  static const _keyThemeMode = "theme_mode";
  static const _keyLanguage = "language";
  static const _keyIsFirstTimeUser = "is_first_time_user";
  static const _keyDestinationAfterLogin = "destination_after_login";

  final GetStorage _box;

  CommonLocalService(this._box);

  Future<void> storeLanguage(Locale locale) {
    return _box.writeStringSecured(
      _keyLanguage,
      locale.languageCode,
    );
  }

  Locale? getLanguage() {
    final languageCode = _box.readStringSecured(_keyLanguage);
    return languageCode != null ? Locale(languageCode) : null;
  }

  Future<void> storeThemeMode(ThemeMode themeMode) {
    return _box.writeStringSecured(
      _keyThemeMode,
      themeMode.name,
    );
  }

  ThemeMode? getThemeMode() {
    final name = _box.readStringSecured(_keyThemeMode);
    return name != null ? ThemeMode.values.byName(name) : null;
  }

  bool isFirstTimeUser() {
    return _box.read<bool>(_keyIsFirstTimeUser) ?? true;
  }

  Future<void> flagOldUser() {
    return _box.write(_keyIsFirstTimeUser, false);
  }

  Future<void> storeDestinationAfterLogin(String destinationAfterLogin) {
    return _box.writeStringSecured(
      _keyDestinationAfterLogin,
      destinationAfterLogin,
    );
  }

  String? getDestinationAfterLogin() {
    return _box.readStringSecured(_keyDestinationAfterLogin);
  }

  Future<void> clearDestinationAfterLogin() {
    return _box.remove(_keyDestinationAfterLogin);
  }

  Future<void> clearWholeSession() {
    return _box.erase();
  }
}
