import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:galerio/base/state/basic/basic_state.dart';
import 'package:galerio/data/service/local/auth_local_service.dart';
import 'package:galerio/data/service/remote/auth_remote_service.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';

@injectable
@singleton
class AuthRepository {
  final AuthLocalService _localService;
  final AuthRemoteService _remoteService;
  final AndroidDeviceInfo _androidInfo;

  AuthRepository(
    this._localService,
    this._remoteService,
    this._androidInfo,
  );

  Future<void> clearLocalSession() async {
    await _localService.clearAuthToken();
    await _localService.clearLastLoginTimestamp();
  }

  bool isLoggedIn() {
    return _localService.getAuthToken() != null;
  }

  Future<UserAuthState> getUserAuthState() async {
    Permission requiredPermission;

    if (Platform.isAndroid == true) {
      if (_androidInfo.version.sdkInt <= 32) {
        requiredPermission = Permission.storage;
      } else {
        requiredPermission = Permission.photos;
      }
    } else {
      requiredPermission = Permission.photos;
    }

    final status = await requiredPermission.status;
    if (status.isGranted || status.isLimited) {
      return UserAuthState.authorized;
    } else {
      return UserAuthState.unauthorized;
    }
  }
}
