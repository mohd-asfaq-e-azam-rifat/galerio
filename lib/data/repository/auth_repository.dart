import 'package:galerio/base/state/basic/basic_state.dart';
import 'package:galerio/data/service/local/auth_local_service.dart';
import 'package:galerio/data/service/remote/auth_remote_service.dart';
import 'package:injectable/injectable.dart';

@injectable
@lazySingleton
class AuthRepository {
  final AuthLocalService _localService;
  final AuthRemoteService _remoteService;

  AuthRepository(
    this._localService,
    this._remoteService,
  );

  Future<void> clearLocalSession() async {
    await _localService.clearAuthToken();
    await _localService.clearLastLoginTimestamp();
  }

  bool isLoggedIn() {
    return _localService.getAuthToken() != null;
  }

  UserAuthState getUserAuthState() {
    if (isLoggedIn() == true) {
      return UserAuthState.authenticated;
    } else {
      return UserAuthState.unauthenticated;
    }
  }
}
